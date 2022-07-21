Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCA957CA2B
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 13:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbiGUL7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 07:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbiGUL7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 07:59:42 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9903079ED3;
        Thu, 21 Jul 2022 04:59:41 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id mf4so2785933ejc.3;
        Thu, 21 Jul 2022 04:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a2m1SZg7h2oHboY4NytPHUqMWEZ4cTDRU1p3Uh7JG+s=;
        b=Epo4QTTd7Rmf98WYXfniuwZVegSEbuoqug8aWUntuRbDRsemnS1wNPmrlHKp5ywF8K
         46o+vGGjdO36dzhhuR119Vy2PL2m0LJDB1OunDXXMiZPUSbv8qLV81aZNz7yURhEKKQV
         qONo5//m4kDf/aZNOBobcaDuHaf47RluHRrFQas0s28JhGbuNoYpTOSykMcLWdI+pWRG
         dj54yl2wf/L0zZ48XsVIaBp0jZTUCy7/VKCZTN/aCdDtbw1QcpC8vqeKb7aXL+lAq35X
         hJaOZ+Tpg7pQUU0olzJuXjIS2UeqGM0OkzI2BkF6boaQTwpjPj5VZHEqHP2T76i0xNWn
         GwUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a2m1SZg7h2oHboY4NytPHUqMWEZ4cTDRU1p3Uh7JG+s=;
        b=ik69EZvvrnbn7Ta3mTHBOH40GglXtODuDw+tZEPLRtwnumdYmbFpJrnhEIBcu9AIqu
         /EXd4oOy2UAA7QvAhKrLYyqesRbRCMxDGAe3uj0bGYAS5+YrPk6Rs1+I95yJlOPOtx4P
         wnub863jDPIqk9r5Y/qM+w8Ihq5qv99PmYHMXxZWvgEkSmBF3V9SIyZucBnOWr9vm4zk
         AUl6aNKhO4wd8Eb/2ZsVTNGOAAsGcsaCnrgoyUc0uoxlfOVrtkuvf0+wNO41m5lzYgue
         LkCNzq6yTqPitkCYEbww/Ce4ay97FVhxSXK0utyf3FeFMXtWmQDxp6VJmVTJFsnam8Rf
         8L8g==
X-Gm-Message-State: AJIora+ycBiABRVytvlXCBlUhYVm+oXkalztELh/puuPqrZ4zUw/eFYc
        I5RMADaI6hbwvNWY/OBkcBg=
X-Google-Smtp-Source: AGRyM1sgsgI/WSY+ey9uZVcDNSpjjPoqNQrVadgcVf4CT98XxbJLOlIlRDjYuFPJo0Q/oTsPUzORDA==
X-Received: by 2002:a17:907:3daa:b0:72b:7656:d4d2 with SMTP id he42-20020a1709073daa00b0072b7656d4d2mr40394554ejc.166.1658404779830;
        Thu, 21 Jul 2022 04:59:39 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id v17-20020a056402175100b0043bb69e1dcfsm870539edx.85.2022.07.21.04.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 04:59:38 -0700 (PDT)
Date:   Thu, 21 Jul 2022 14:59:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <20220721115935.5ctsbtoojtoxxubi@skbuf>
References: <20220708091550.2qcu3tyqkhgiudjg@skbuf>
 <e3ea3c0d72c2417430e601a150c7f0dd@kapio-technology.com>
 <20220708115624.rrjzjtidlhcqczjv@skbuf>
 <723e2995314b41ff323272536ef27341@kapio-technology.com>
 <YsqPWK67U0+Iw2Ru@shredder>
 <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
 <Ys69DiAwT0Md+6ai@shredder>
 <648ba6718813bf76e7b973150b73f028@kapio-technology.com>
 <YtQosZV0exwyH6qo@shredder>
 <4500e01ec4e2f34a8bbb58ac9b657a40@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4500e01ec4e2f34a8bbb58ac9b657a40@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 05:53:22PM +0200, netdev@kapio-technology.com wrote:
> > 3. What happens to packets with a DA matching the zero-DPV entry, are
> > they also discarded in hardware? If so, here we differ from the bridge
> > driver implementation where such packets will be forwarded according to
> > the locked entry and egress the locked port
> 
> I understand that egress will follow what is setup with regard to UC, MC and
> BC, though I haven't tested that. But no replies will get through of course
> as long as the port hasn't been opened for the iface behind the locked port.

Here, should we be rather fixing the software bridge, if the current
behavior is to forward packets towards locked FDB entries?
