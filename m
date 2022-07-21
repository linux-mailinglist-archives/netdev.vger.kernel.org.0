Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EED657CA10
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 13:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiGULyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 07:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbiGULyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 07:54:53 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B2883234;
        Thu, 21 Jul 2022 04:54:52 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id fy29so2662470ejc.12;
        Thu, 21 Jul 2022 04:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c2k9Gs9aq7wD8Q/GIeDAjL6HQrb7wXOBzG+CfyfPzhY=;
        b=ACF8TqJG/PCVXLN/DfmbuzxuxGjPaw8maXBAuewHlJ9tumjTSGSDkhS2sVl3mLiHWH
         gCsWXSI0FmZsI34OPo09XlR6d0q73kcocEcWWkKGjzE3a/SnNxwefEu0fWJe685Ee1bh
         hr76tigPIOAmzmWMQbOcJl98m4kLXsEmHlFrh8NsMF6Wgk180kD1qEg0trdSvLAXMwBy
         m3yuAKekMn8UkwpXDJcG2Vu9OTQUQp0DWYtTLeXC54pTyG2QSdPeVLqWSbJ9mZD+WR0E
         Kn3/kl+f8xFbpe2MgcBwchwQdpRzPAIdytrWqM4CVkxx1m25gChgQcEbUAhWaqWj8AxP
         RQNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c2k9Gs9aq7wD8Q/GIeDAjL6HQrb7wXOBzG+CfyfPzhY=;
        b=qCgm7MaxHxLo3Ey3mle0KhbZk2GtVcJBYIo6qF9+lVEQpTkOrHGFIQGBij8Y8ZCbxC
         62tspZQWRvhCN6MfKEGaAjdObTkgToQZWvWAyUFdOonaSmv8K0dtKLZPwrFB5Pz/9Xp/
         Qr5mgpe8aBo/wmQ6FTPLALvjhwGDtvWKln7Wta059YLMZGUmWF9J0gR+JSkSuixnkm3L
         3z18pn7vSyZRPB6YKdyXaPC6XCJVlNlBUgFl9B11hQIjC3FjZgfqb+aoHRHpNxpfwa88
         JUlHsWwBzK3QtiKJH+75FMBWK0lV9R73e8fYksparxYmA/rL1mYnxUAUPZFr7djxXHL6
         IthA==
X-Gm-Message-State: AJIora//RBrwzxzjHtWTBEGgnlwnLa0i0Evxt03WqP8Ilvfd3UIG5HVa
        4w8GI+wMogaPNL1wlMzJSrw=
X-Google-Smtp-Source: AGRyM1sP7uU7BnTye1iWJUkXjwdHTa35FSpU/Q4kXU1vdqrQ7JS0A4/bkQTt5/kxqjiYmY2pRwPVgA==
X-Received: by 2002:a17:906:730a:b0:72f:6ce7:8acd with SMTP id di10-20020a170906730a00b0072f6ce78acdmr7574235ejc.233.1658404490767;
        Thu, 21 Jul 2022 04:54:50 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id g2-20020a170906538200b0072b1bb3cc08sm788567ejo.120.2022.07.21.04.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 04:54:50 -0700 (PDT)
Date:   Thu, 21 Jul 2022 14:54:47 +0300
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
Message-ID: <20220721115447.cxfiromwtxw4ukv4@skbuf>
References: <YsqPWK67U0+Iw2Ru@shredder>
 <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
 <Ys69DiAwT0Md+6ai@shredder>
 <648ba6718813bf76e7b973150b73f028@kapio-technology.com>
 <20220717125718.mj7b3j3jmltu6gm5@skbuf>
 <a6ec816279b282a4ea72252a7400d5b3@kapio-technology.com>
 <20220717135951.ho4raw3bzwlgixpb@skbuf>
 <e1c1e7c114f0226b116d9549cea8e7a9@kapio-technology.com>
 <20220717150821.ehgtbnh6kmcbmx6u@skbuf>
 <480c7e1e9faa207f37258d8e1b955adc@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480c7e1e9faa207f37258d8e1b955adc@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 06:10:22PM +0200, netdev@kapio-technology.com wrote:
> Okay, I see the problem you refer to. I think that we have to accept some
> limitations unless you think that just zeroing the specific port bit in the
> DPV would be a better solution, and there wouldn't be caveats with that
> besides having to do a FDB search etc to get the correct DPV if I am not too
> mistaken.

No, honestly I believe that what we should do to improve the limitation
is to have proper ATU database separation between one VLAN-unaware
bridge and another (i.e. what is now MV88E6XXX_FID_BRIDGED to be one FID
per bridge).
