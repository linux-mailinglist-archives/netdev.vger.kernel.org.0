Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D33581833
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 19:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236009AbiGZRNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 13:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiGZRNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 13:13:39 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF25D1D0EF
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 10:13:37 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id l15so17005251wro.11
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 10:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ya59pOWC/XkVrMitaEoIHMQum8UZ4W56I2jQyTE7Afc=;
        b=T9wsWsDZCSRyArkoEygWMZ84dK7pmksiM19pgP6ZencDgQz9I87DF8v+Z4gVR++a0A
         aOkwI7DoOLOqf7kjK5VW+FWar+3HXIk7vb1dveB2MTzKBVY5Xb90iSg/SWyOyTLENctq
         FBp1LzhEr+YgljBbjZqfjfY6a04ldXtV6sfTNmEWT391pFuZx5fnAhaIZLJHo5OmR2i/
         WkqVE259XC/JFDQrvzDn9OPTRf8tyxH7qJAsuhgVFmSOeOcrZmT6CDCVeBl+L7MEWFJr
         6faYYUGcXKoFvnLp4xpSo1etfhsNltKNzj09E6a8qUELuBIlT/l7Lpdw/rWVSoHa/XwL
         c5cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ya59pOWC/XkVrMitaEoIHMQum8UZ4W56I2jQyTE7Afc=;
        b=qdSySI5ilGjmdSV81MwUIFQd8ZacYT5V0k10FuRkjoTBmYsUYsIeTsWWHtZjAohKTz
         JCdNRWNtkGrRN7I1k/3M9DpLrNR1ZWl3ZE6A36ToDxqzOZtFnvtwEeHh0EMZCNuxGg32
         4KM22Kt2dtAiMrFmI2gdScDz6CXIwR/MKNcQkvepavY5boqGf64PfuwhCfY3dUeUUY2Z
         76aqZwfaAds0Y/HyNmv3Wlwqgjsej2IHfIBAAlt8rfQ2FJrLiB3RUmWVhKFDEAt1wlg/
         lyrAP+szd59J2pApVIqHQYksv0Ypw+qadEO/CvTybbtVvjVKZxH68yJfPMKIr2YQOq5L
         DtpA==
X-Gm-Message-State: AJIora+D/xWq97V7y5TOOt+2rjQH8YbslL3KOgvzmUaV3AB2RD+L0YJK
        zNEWJZTPs2wsjbJemNIZ+G6bVQ==
X-Google-Smtp-Source: AGRyM1uFm115Jivt3DuHTddFTV9E6c90o85gIA6fcbdAlG6Yc5ksQjmmRm1wO/n0KyYbfoSY6cYbkQ==
X-Received: by 2002:a05:6000:60d:b0:21e:927e:d446 with SMTP id bn13-20020a056000060d00b0021e927ed446mr5323471wrb.529.1658855616163;
        Tue, 26 Jul 2022 10:13:36 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n11-20020a05600c304b00b003a320b6d5eesm20836679wmh.15.2022.07.26.10.13.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 10:13:35 -0700 (PDT)
Message-ID: <b2d5dc2b-c525-44b4-48cf-7d56add05a14@arista.com>
Date:   Tue, 26 Jul 2022 18:13:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net] tcp: md5: fix IPv4-mapped support
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Brian Vazquez <brianvv@google.com>,
        David Ahern <dsahern@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>
References: <20220726115743.2759832-1-edumazet@google.com>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <20220726115743.2759832-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/26/22 12:57, Eric Dumazet wrote:
> After the blamed commit, IPv4 SYN packets handled
> by a dual stack IPv6 socket are dropped, even if
> perfectly valid.
> 
> $ nstat | grep MD5
> TcpExtTCPMD5Failure             5                  0.0
> 
> For a dual stack listener, an incoming IPv4 SYN packet
> would call tcp_inbound_md5_hash() with @family == AF_INET,
> while tp->af_specific is pointing to tcp_sock_ipv6_specific.
> 
> Only later when an IPv4-mapped child is created, tp->af_specific
> is changed to tcp_sock_ipv6_mapped_specific.

Makes sense. Sorry, I didn't spot it at that moment.

> 
> Fixes: 7bbb765b7349 ("net/tcp: Merge TCP-MD5 inbound callbacks")
> Reported-by: Brian Vazquez <brianvv@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Dmitry Safonov <dima@arista.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Leonard Crestez <cdleonard@gmail.com>

Reviewed-by: Dmitry Safonov <dima@arista.com>

Thanks,
           Dmitry
