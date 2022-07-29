Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88940585685
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239136AbiG2VeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239039AbiG2VeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:34:20 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFF48BA88;
        Fri, 29 Jul 2022 14:34:20 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id g12so5698045pfb.3;
        Fri, 29 Jul 2022 14:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=NwtNtEQOHc2dF/HVDCZwPgex3AMPeOUoh7eFgk5kVb8=;
        b=qYiJxzSxSAZGkbrV4xWHPhc0B0LDGODI6qnSGfize8u6vRhtpKe8wlhtCsxmAkp2Ek
         VsF+PBflLgNh5xUnV/4KnvkeZdR76CHcmKkrlMJopZfIkI+9XN2Z0QSTn2DPVWdPdaYU
         jvgyRfCXEkt5Qz9m00qalhLVCmwWOspaERAFQ0lyj3rUJ1PyE34ObV5WFP/kpom8bSBi
         fBiQKIdEgu7aLRp0TpuF3GG/+XjFEE5BghuOwJ0wD1vc39iwxqvoKqjJ+xed7iFKbrfL
         d2XH1E67jxjhEy7xDa5tP60NG+/Y1L/z+IOWw3jG4CiI5Rydr2sJgPHRmzotDpd73sOI
         Gw7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=NwtNtEQOHc2dF/HVDCZwPgex3AMPeOUoh7eFgk5kVb8=;
        b=rM+Q80sZxJK418JxO9P9nfFxrC3xmGETCue3ERxTs6XdftEI34A4mbs8vFR40HRRKg
         9fEGQBx9WbH9fktlc5rjzWWg3/UYCaUIgrbWgoYAv69CaivbDIUuoU8uwYJ5R0gYgVS6
         fN9cP0YyOvwZl9uwLp1QL/72DVtkc+vjZtmGp9SOR0/5Gl1EEEDldf/lSvY+/UIErlwW
         SKgKWMAKXjBEzk/ACzuwNzDSB5i93So/4UBwpBsby2snayvIXNEC/nYKLx6x7q4yOqHj
         ya/lIlAOBIQMZqweiud2oOC51xH4mTA5fUd4MIl7YBcjJpkbg/Np4gNANH4pcXeOSDXz
         v02g==
X-Gm-Message-State: AJIora+ChEgdmixgO08QldRIUKvx+nALamnJzypYFoGILHZkBRYNnJfB
        wdJ6OQM8pfIGemh2iHiu9AlTtDxoUgM=
X-Google-Smtp-Source: AGRyM1tF+sX3o1zzdc3k3Yw6oaRfWtMRIrg3HjP2qBu9lvgajYhy1tVjw53wyYg/DTyS0trg1w2VGQ==
X-Received: by 2002:a62:3884:0:b0:52b:ead1:7bc8 with SMTP id f126-20020a623884000000b0052bead17bc8mr5361063pfa.78.1659130459431;
        Fri, 29 Jul 2022 14:34:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t8-20020a170902e84800b0016d1e514ec5sm4205524plg.139.2022.07.29.14.34.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 14:34:19 -0700 (PDT)
Message-ID: <8191e697-e632-642e-a244-f65f738c388e@gmail.com>
Date:   Fri, 29 Jul 2022 14:34:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next PATCH v5 04/14] net: dsa: qca8k: move qca8k
 read/write/rmw and reg table to common code
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-5-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220727113523.19742-5-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/22 04:35, Christian Marangi wrote:
> The same reg table and read/write/rmw function are used by drivers
> based on qca8k family switch.
> Move them to common code to make it accessible also by other drivers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
