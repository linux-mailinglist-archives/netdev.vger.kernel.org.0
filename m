Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D7A6966AF
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 15:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbjBNOZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 09:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232493AbjBNOZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 09:25:54 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75DD3C09
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:25:43 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id hx15so40461186ejc.11
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MhJWjz67ot3/svnK05CqpxYj6HtxXv7YnP1HPDGy+XA=;
        b=O8ObkUFi7kYtr/4ftsy80D4UpgRXSBl97Af3u44486NtNvnm/GoQbVo8mSlXSBby5r
         U/6P2SNGRp2x5pJ9aOWwVbH4fiSusWeJNFJKmnZIyNEX3uEgWgiGSQv89inzlVsdYEVG
         W8KmJtpGQVHF768Cmlf7D4F4MvNOArk42PdrL87+yTq1idYSwKj4fiivwe2fzxvcMdeJ
         xZ7Q8qwOTzkmMySARgTIILbZO6yxCRtHNpiXHjoSqx64oJ36EBxoqXKTZiLa7ZKNcIBo
         khIU+jDc0wVj8dpWK701vpE3tCtP7wUiVYTV3eXu4tDQszGJsyS1da+iJCxZdek+F4e2
         C/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MhJWjz67ot3/svnK05CqpxYj6HtxXv7YnP1HPDGy+XA=;
        b=3jyxmRon3xreaD/GC3PzsrJRGOywclzNJ90j+m5bbRAK/4/XRSqZlbSk1fmbt+8LNc
         WnZMqXmg3fxRbe/WtQFnVPA8QrM11MTtOJvrVdVg1i02iptVDuXMzNRGTMupeAJnL85l
         ks6NUOicorCbqhQiDnblpRPQrvzfsMF8OZma9tOSF9SDV2OqMYLpQ8sHjE4dm4oooWM0
         OreaH41fGL5WvCl3Y7ALYgePFT7/hwv0JXjVbJTYpCPpC8D+Iuyau9MqleEPSWqS2F1N
         yw+GJM5x9izcAZwqAODf3pbNMFq4tgYPH4tDM04JTnQzSXz0a8uqHsRL5Sn3TGYG8Svv
         LK/A==
X-Gm-Message-State: AO0yUKUC8OdDM1wRExX6U24lrPnHUOWm+etgblhjcLicCwPwiYrUwLeJ
        VKXj3VHHkL3GjTjWrSX10GUwSQ==
X-Google-Smtp-Source: AK7set8Zu39N8ftsSq9q1/YeOG/YidcXbnMDvmwao408Pa86ZrgylZZp8wKSyFRrvDIR+hOhAR15jQ==
X-Received: by 2002:a17:907:2044:b0:882:239e:23c0 with SMTP id pg4-20020a170907204400b00882239e23c0mr3382846ejb.12.1676384742352;
        Tue, 14 Feb 2023 06:25:42 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ov38-20020a170906fc2600b008af574e95d7sm6400173ejb.27.2023.02.14.06.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 06:25:41 -0800 (PST)
Date:   Tue, 14 Feb 2023 15:25:40 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, stephen@networkplumber.org, dsahern@gmail.com
Subject: Re: [PATCH net-next 0/5] net/sched: Retire some tc qdiscs and
 classifiers
Message-ID: <Y+uZ5LLX8HugO/5+@nanopsycho>
References: <20230214134915.199004-1-jhs@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214134915.199004-1-jhs@mojatatu.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 14, 2023 at 02:49:10PM CET, jhs@mojatatu.com wrote:
>The CBQ + dsmark qdiscs and the tcindex + rsvp classifiers have served us for
>over 2 decades. Unfortunately, they have not been getting much attention due
>to reduced usage. While we dont have a good metric for tabulating how much use
>a specific kernel feature gets, for these specific features we observed that
>some of the functionality has been broken for some time and no users complained.
>In addition, syzkaller has been going to town on most of these and finding
>issues; and while we have been fixing those issues, at times it becomes obvious
>that we would need to perform bigger surgeries to resolve things found while
>getting a syzkaller fix in place. After some discussion we feel that in order
>to reduce the maintenance burden it is best to retire them.
>
>This patchset leaves the UAPI alone. I could send another version which deletes
>the UAPI as well. AFAIK, this has not been done before - so it wasnt clear what
>how to handle UAPI. It seems legit to just delete it but we would need to
>coordinate with iproute2 (given they sync up with kernel uapi headers). There

I think we have to let the UAPI there to rot in order not to break
compilation of apps that use those (no relation to iproute2).


>are probably other users we don't know of that copy kernel headers.
>If folks feel differently I will resend the patches deleting UAPI for these
>qdiscs and classifiers.
>
>I will start another thread on iproute2 before sending any patches to iproute2.
>
>Jamal Hadi Salim (5):
>  net/sched: Retire CBQ qdisc
>  net/sched: Retire ATM qdisc
>  net/sched: Retire dsmark qdisc
>  net/sched: Retire tcindex classifier
>  net/sched: Retire rsvp classifier

set-
Acked-by: Jiri Pirko <jiri@nvidia.com>

