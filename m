Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A5E691945
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 08:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbjBJHgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 02:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjBJHgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 02:36:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB6B765F6
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 23:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676014556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yYEWX7jqjucAfdMA3biMOX8rqv+ik86o/ADDxCienSs=;
        b=EDGVguX+HEQy8PybgRANqCzArQQRyYsYym0zB8tTO+kAkqCODiDdErJyToylPwYTKKCtRk
        sovxOoqDCD70seE3IX7yv+W3dACZpQPgh2tdhIKDRJbLusKqOxqo6StdiNHMEuEM4w5RC0
        Fjr+ZznVZMBWv4oblX+jKNJtfUxDXeU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-204-FYYZiWEUNoap-UWB-MWq8A-1; Fri, 10 Feb 2023 02:35:54 -0500
X-MC-Unique: FYYZiWEUNoap-UWB-MWq8A-1
Received: by mail-ed1-f72.google.com with SMTP id b12-20020a056402278c00b004aad86c5723so2979481ede.5
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 23:35:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yYEWX7jqjucAfdMA3biMOX8rqv+ik86o/ADDxCienSs=;
        b=O5BuRcDLMS3OSpmtpCABkd4I+2EK9EDs0/tirqjDD6ugEUEzqYOsC8KFcZVx9Rlw1e
         Cfbmv3wHpqW4m6fynsrV13rs9P1XAiX7rtbEzEaawhsQ4FbKnB4EbfzzkeX1AcB2gHjb
         WLmh50TEPHOj3VCNUWVI34jObm3FAxOOAnXhqYwzd2FLQpBIhpl/ePOawKDhiapeLNzW
         qPYaUshBi4sStRRHjnoEtoYzhVx0F0eesbTob8nqjU3lJMlwOnjy9aR9qcHMjPPSgW/a
         xF09kETRL2PEClVrWpWju/bam9nvPDUANFNR0Gum96OUbd55TPnCI1+4Xkp4OqEFew8A
         iMSQ==
X-Gm-Message-State: AO0yUKWgHeLebiBZzsL66qQ2BaKgpMcf4XJaOUecZij7YlnZE+4nre5W
        vuHofgLnLRwNQOYny3wAnELwe6B+zwuIOHM3Knnrg7jheJj9DlOVuyrJCdKWhhKU7eEsskupt5Q
        Yryh58C+TiwyOEIMXtJnF1w==
X-Received: by 2002:a50:d0c2:0:b0:4ab:255e:bd6e with SMTP id g2-20020a50d0c2000000b004ab255ebd6emr3243763edf.27.1676014552989;
        Thu, 09 Feb 2023 23:35:52 -0800 (PST)
X-Google-Smtp-Source: AK7set/ouhqSt0CZoGDOL+o9lywStvnOVeGxmXezs5trlWDgApfJQqfQuT4q+7FFgE349aab9bsPZQ==
X-Received: by 2002:a50:d0c2:0:b0:4ab:255e:bd6e with SMTP id g2-20020a50d0c2000000b004ab255ebd6emr3243745edf.27.1676014552750;
        Thu, 09 Feb 2023 23:35:52 -0800 (PST)
Received: from [10.39.192.156] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id r12-20020a50c00c000000b0049dd7eec977sm1820128edb.41.2023.02.09.23.35.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Feb 2023 23:35:51 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     pshelar@ovn.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiangxia.m.yue@gmail.com,
        simon.horman@corigine.com, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: openvswitch: fix possible memory leak in
 ovs_meter_cmd_set()
Date:   Fri, 10 Feb 2023 08:35:50 +0100
X-Mailer: MailMate (1.14r5942)
Message-ID: <6582F9D7-D74B-4A4A-A498-1B3002B9840E@redhat.com>
In-Reply-To: <20230210020551.6682-1-hbh25y@gmail.com>
References: <20230210020551.6682-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10 Feb 2023, at 3:05, Hangyu Hua wrote:

> old_meter needs to be free after it is detached regardless of whether
> the new meter is successfully attached.
>
> Fixes: c7c4c44c9a95 ("net: openvswitch: expand the meters supported num=
ber")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>

Thanks for doing a v3. The change looks good to me!

Acked-by: Eelco Chaudron <echaudro@redhat.com>

> ---
>
> v2: use goto label and free old_meter outside of ovs lock.
>
> v3: add the label and keep the lock in place.
>
>  net/openvswitch/meter.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> index 6e38f68f88c2..f2698d2316df 100644
> --- a/net/openvswitch/meter.c
> +++ b/net/openvswitch/meter.c
> @@ -449,7 +449,7 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, s=
truct genl_info *info)
>
>  	err =3D attach_meter(meter_tbl, meter);
>  	if (err)
> -		goto exit_unlock;
> +		goto exit_free_old_meter;
>  	ovs_unlock();
>
> @@ -472,6 +472,8 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, s=
truct genl_info *info)
>  	genlmsg_end(reply, ovs_reply_header);
>  	return genlmsg_reply(reply, info);
>
> +exit_free_old_meter:
> +	ovs_meter_free(old_meter);
>  exit_unlock:
>  	ovs_unlock();
>  	nlmsg_free(reply);
> -- =

> 2.34.1

