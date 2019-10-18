Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 467A1DD557
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733106AbfJRX2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:28:30 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34839 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfJRX2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:28:30 -0400
Received: by mail-qt1-f196.google.com with SMTP id m15so11579897qtq.2
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 16:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ihVTg/TuO+oAKMUj+Gb5l3NeADnasNlEoFEFehbmLY=;
        b=QxhvA8yG1BMxVdYzT1nW4R7xP+A6ThWAdBDpYkUZx8n0f08rzPtC5hZdCJShO8G8qq
         VYf3YBKsKppQyIzffvuxsIQppSj1TXdLJGxZYVZhFHlwsX42ebBsLghy0wG+lAg0TLKT
         WTARqCB4BN90cRXMWo3gLxlZv8CfcaCfl23NYgJ0EPUqpv74RtK2KZXUapjS2Pbi1v7j
         xWu/Yx998gH7Jum4XEzSekDG+OVq1bu8vUS/YWVmQbIEO+pHn1LK6dIg1LCCF12mQS6p
         tu3FbQF/uNe9PK9VJDIq8Vn0fdB/OD1n4dHT7HtMiFZxFXYWNmKEa2QCQM/0ulTJim6u
         lxvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ihVTg/TuO+oAKMUj+Gb5l3NeADnasNlEoFEFehbmLY=;
        b=UwM8W5zYJM6Gb7h3rh5X0L+c0ZKwOhbIZKOtfMVq0x/+SKmgFZ3aZzl37GxhcEOoo2
         bVUCIKamDilVhzg/VycI3ywczr/uMC787ZBt41m2N1WJPe4ueKpZJqQjJxs4ME8Pj0jR
         HNTQZpHZ2A+Z56Fkg3U5OKRTnrSlYBfNO607naPejAHjsFjaNUNr4l6RdkwBOoOTwIkO
         Hb/UY68PlyqB5vmlY4dIJ77FcBkiMzrCrohjk+0DzNpYrUArsLf9JSOy2JxxT84RborG
         y2a58n9q6QGVpDEX6Auun+bD/ri+AdtWR0IBuesw+0SAWZztBscjcYlO8sWCvfZCEqBv
         EZYw==
X-Gm-Message-State: APjAAAWxwhrrmETdqSix8HgKCuNF2TPkMMSLd9tJpt5u9rDGsBL4Qp3N
        m3vFSThByH2+6SfoXCO52Re/NsYSzdRaPaiGTZA=
X-Google-Smtp-Source: APXvYqzmnqmR/8fLHWG8mbmOETUTOg2Q5GJ1oOUfLKGbDwZfPthzwJtu4vepbxXEb1Nwf+fuH3nwMK/YZK5HMY2ibUQ=
X-Received: by 2002:a05:6214:725:: with SMTP id c5mr12511057qvz.175.1571441309680;
 Fri, 18 Oct 2019 16:28:29 -0700 (PDT)
MIME-Version: 1.0
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com> <1571135440-24313-10-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1571135440-24313-10-git-send-email-xiangxia.m.yue@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 18 Oct 2019 16:27:53 -0700
Message-ID: <CALDO+SZ1XB-Eb0KfWGvty6ievPRFKP7qcyA3+ptfYbjm7xHUQA@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v4 09/10] net: openvswitch: don't
 unlock mutex when changing the user_features fails
To:     xiangxia.m.yue@gmail.com
Cc:     Greg Rose <gvrose8192@gmail.com>, pravin shelar <pshelar@ovn.org>,
        "<dev@openvswitch.org>" <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 5:56 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Unlocking of a not locked mutex is not allowed.
> Other kernel thread may be in critical section while
> we unlock it because of setting user_feature fail.
>
> Fixes: 95a7233c4 ("net: openvswitch: Set OvS recirc_id from tc chain index")
> Cc: Paul Blakey <paulb@mellanox.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> ---

LGTM
Acked-by: William Tu <u9012063@gmail.com>


>  net/openvswitch/datapath.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 9fea7e1..aeb76e4 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -1657,6 +1657,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>                                 ovs_dp_reset_user_features(skb, info);
>                 }
>
> +               ovs_unlock();
>                 goto err_destroy_meters;
>         }
>
> @@ -1673,7 +1674,6 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
>         return 0;
>
>  err_destroy_meters:
> -       ovs_unlock();
>         ovs_meters_exit(dp);
>  err_destroy_ports_array:
>         kfree(dp->ports);
> --
> 1.8.3.1
>
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
