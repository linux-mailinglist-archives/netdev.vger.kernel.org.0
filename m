Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6FC67113C
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 03:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjARCgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 21:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjARCgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 21:36:37 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD504FAE3
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 18:36:35 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id p66so15856126iof.1
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 18:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mUP3oSOonc9volL6dG1Z3wQ4RtxFMEeIMIOReDCoeO8=;
        b=O9w5MLRPjm8HlNCCxsdjTjfWvBVGsEY1mZUHqCiHoPYMZqQL5izE9oyEJROU50GuwE
         icNGyPiDdRypXJdWvzOohu9m4V5QUuT5FlvVSMQ6VAgGMFIaSnLysCQdA+Liv+st88c9
         s4IRqjo0W/4UDKHdsxdJTas5rcGlLuL2hpyzKp54nEBNXIafnvTHj+KMx3LyWxIj34Iv
         3XJHs2Q3wqTmb6k5smwYLbj75+XNQtG4ZHKcirjTUcUtNeqM9ibzIj6HP6t3pdRkV9cO
         gHGzkXPpP5ePGVBRpjYFGLjzzwmrWDXdNqSY7EMykH9uxoV3jkwe6EWWYJ/2neWP8Mx/
         eG7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mUP3oSOonc9volL6dG1Z3wQ4RtxFMEeIMIOReDCoeO8=;
        b=ye1ioy++BgxZ1CtNfCIlHFR/VLDQtYCZpW0jDrO0JmEfqu9DaoYi4qWhCTKpAkEBRs
         mb1yWTjEaZSil8eh6D4aVZBBiZ8UbD/+6J9t0QROVkjFRWZ1nGORbAYmq7y06+dZp6Hm
         LRd80fGxkeWKwcJm2ogazxmNoKfJ2dxNDO/+AWCSTmdxl+52Km1/4y4Ef5tCerb1l+wP
         uXP6HuRrkZtiYq36MUh0U3T4WYiYjXcWbcOKQEShHPoa1RFmdKp4vMHqTfGnnKsKAb+A
         h40uwWB74l3Rj1Q3FSq/ZPxlmPZfcqWuzOTH3DiW/JVGInFdbZHhGMBf4Bv/AjcRfrrT
         r8jQ==
X-Gm-Message-State: AFqh2kp0bY6VfuiMrvjGtzGw7k9OO6o89EzHkzfs4DuzmxbtHBShNxTZ
        xsyjLvx7jkeFwohXl3tO3Qc=
X-Google-Smtp-Source: AMrXdXuoFxERoO0Gg/Xsw9Qs12zjACBJKbIf8bFnbddzVcQqsoY3as3cf8Tl98lSDwqoq9FtBI1ESQ==
X-Received: by 2002:a05:6602:215a:b0:6d6:4daf:623f with SMTP id y26-20020a056602215a00b006d64daf623fmr3408059ioy.6.1674009395139;
        Tue, 17 Jan 2023 18:36:35 -0800 (PST)
Received: from ?IPV6:2601:282:800:7ed0:3dc4:7b4f:e5b1:e4d8? ([2601:282:800:7ed0:3dc4:7b4f:e5b1:e4d8])
        by smtp.googlemail.com with ESMTPSA id d18-20020a0566022d5200b006cecd92164esm11089982iow.34.2023.01.17.18.36.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jan 2023 18:36:34 -0800 (PST)
Message-ID: <09ce6f16-dc14-1936-ebeb-d3077c6c5b70@gmail.com>
Date:   Tue, 17 Jan 2023 19:36:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net] Revert "net: team: use IFF_NO_ADDRCONF flag to
 prevent ipv6 addrconf"
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>
References: <63e09531fc47963d2e4eff376653d3db21b97058.1673980932.git.lucien.xin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <63e09531fc47963d2e4eff376653d3db21b97058.1673980932.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/17/23 11:42 AM, Xin Long wrote:
> This reverts commit 0aa64df30b382fc71d4fb1827d528e0eb3eff854.
> 
> Currently IFF_NO_ADDRCONF is used to prevent all ipv6 addrconf for the
> slave ports of team, bonding and failover devices and it means no ipv6
> packets can be sent out through these slave ports. However, for team
> device, "nsna_ping" link_watch requires ipv6 addrconf. Otherwise, the
> link will be marked failure. This patch removes the IFF_NO_ADDRCONF
> flag set for team port, and we will fix the original issue in another
> patch, as Jakub suggested.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  drivers/net/team/team.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
> index fcd43d62d86b..d10606f257c4 100644
> --- a/drivers/net/team/team.c
> +++ b/drivers/net/team/team.c
> @@ -1044,7 +1044,6 @@ static int team_port_enter(struct team *team, struct team_port *port)
>  			goto err_port_enter;
>  		}
>  	}
> -	port->dev->priv_flags |= IFF_NO_ADDRCONF;
>  
>  	return 0;
>  
> @@ -1058,7 +1057,6 @@ static void team_port_leave(struct team *team, struct team_port *port)
>  {
>  	if (team->ops.port_leave)
>  		team->ops.port_leave(team, port);
> -	port->dev->priv_flags &= ~IFF_NO_ADDRCONF;
>  	dev_put(team->dev);
>  }
>  

What about the other patches in that set - failover device and bonding?
