Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C3E39A603
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhFCQp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:45:27 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:45806 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhFCQp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 12:45:27 -0400
Received: by mail-lj1-f178.google.com with SMTP id m3so7915559lji.12;
        Thu, 03 Jun 2021 09:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nuRSAtZPeAYZdMLrOA69vUXLR2r41hPNT21AloEibuE=;
        b=ZQz3ZTOf0Y/MZx10PyGdhVsaZCuvAsy7tCceX45QGgZ0k9HwnJsnZHOUNiZTUPySnV
         6UHM97aWhEt3dLkS/OPo4Gcxd8jAc2YDMWcSbGyTTpv3aRQ8Sx+NmIOopD1amVaCoh1t
         ItjXmOyDWlzeoEMxlHKfCw0I9Xy4KeFjHe8Mn+Abt7szSRdPFCvJSv4zKhDEQebAxOgg
         NODzemGJEe4pxXjwR8/GyISWxuRiDjD2XzBPN8VW+SJTRM9USTZpMzkiXbmO0snYY1b3
         8NbGAoohfutQilRCnBKNfh7BLjBfgKhzSCDANjESpLJrTdrJVKfv8fmmofYJo5nRYRvb
         XoKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nuRSAtZPeAYZdMLrOA69vUXLR2r41hPNT21AloEibuE=;
        b=nGg95zjEy0sHWi0vVchgo1xQiKwNjvfOpEhTH+NZri2mpnngdigHL/yz+ycisLKu9K
         xbFdUaZQ5sXA7Kwh39okCUGPe3hRlkI/+xUD5azfAmSIRfrflwep9QF9PWPsWzUCeL2J
         wVi/sxSJ0Y8btiswea5YqizhPQARdZK/honHkQj2YvTGJS5UahgkfglbAdKxZyLuPfz/
         TO2NN8Twt/zRzPRllSFdvtdn82Znt24/8kSfMiU/2HZK+Mvp7+aYaS9Y1OcmfLjzyuhu
         jx+WxVI0pVTERdoVEMlzwIk+OBSTWxLpaLo1KNL6/BL+LG9h0dnuTx8GgOLRE7NTvWB7
         UMew==
X-Gm-Message-State: AOAM530Rsfhr9nxS/HOBDIRT1uc/VbJVjghtpJm1GNovMQD+GOQeRNty
        IRoQSGm9H/BfncjPWns9v4b7wAMuCAM=
X-Google-Smtp-Source: ABdhPJwr9OTWggEswHE0pT6GFsR8fIogF7TJJ7dR9GipsthL0HLexmo2iSFcWhqHdJcTQninWpyWvA==
X-Received: by 2002:a2e:a550:: with SMTP id e16mr215112ljn.136.1622738550178;
        Thu, 03 Jun 2021 09:42:30 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id r22sm411638ljp.129.2021.06.03.09.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 09:42:29 -0700 (PDT)
Date:   Thu, 3 Jun 2021 19:42:27 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        sjur.brandeland@stericsson.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+7ec324747ce876a29db6@syzkaller.appspotmail.com
Subject: Re: [PATCH 3/4] net: caif: fix memory leak in caif_device_notify
Message-ID: <20210603194227.18f48c58@gmail.com>
In-Reply-To: <fcddc06204f166d2ef0d75360b89f6f629a3b0c4.1622737854.git.paskripkin@gmail.com>
References: <cover.1622737854.git.paskripkin@gmail.com>
        <fcddc06204f166d2ef0d75360b89f6f629a3b0c4.1622737854.git.paskripkin@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Jun 2021 19:39:11 +0300
Pavel Skripkin <paskripkin@gmail.com> wrote:

> In case of caif_enroll_dev() fail, allocated
> link_support won't be assigned to the corresponding
> structure. So simply free allocated pointer in case
> of error
> 
> Fixes: 7c18d2205ea7 ("caif: Restructure how link caif link layer
> enroll") Cc: stable@vger.kernel.org
> Reported-and-tested-by:
> syzbot+7ec324747ce876a29db6@syzkaller.appspotmail.com Signed-off-by:
> Pavel Skripkin <paskripkin@gmail.com> ---
>  net/caif/caif_dev.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
> index fffbe41440b3..440139706130 100644
> --- a/net/caif/caif_dev.c
> +++ b/net/caif/caif_dev.c
> @@ -370,6 +370,7 @@ static int caif_device_notify(struct
> notifier_block *me, unsigned long what, struct cflayer *layer,
> *link_support; int head_room = 0;
>  	struct caif_device_entry_list *caifdevs;
> +	int res;
>  
>  	cfg = get_cfcnfg(dev_net(dev));
>  	caifdevs = caif_device_list(dev_net(dev));
> @@ -395,8 +396,10 @@ static int caif_device_notify(struct
> notifier_block *me, unsigned long what, break;
>  			}
>  		}
> -		caif_enroll_dev(dev, caifdev, link_support,
> head_room,
> +		res = caif_enroll_dev(dev, caifdev, link_support,
> head_room, &layer, NULL);
> +		if (res)
> +			cfserl_release(link_support);
>  		caifdev->flowctrl = dev_flowctrl;
>  		break;
>  

One thing Im wondering about is should I return this error
from caif_device_notify()? I look forward to hearing your perspective on
this question and patch series :)



With regards,
Pavel Skripkin
