Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 933EEDF338
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 18:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbfJUQfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 12:35:10 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44989 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729405AbfJUQfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 12:35:07 -0400
Received: by mail-pf1-f193.google.com with SMTP id q21so8735853pfn.11
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 09:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=YQ2SYzDjclp6+UMcXfMKe/dCfkknHxuiGOrHRSVn0cA=;
        b=ZvioHrwPqgA32sqk/ZfXl+AIKFsddUO2tNAqbJtu4tCcRANhGvReU9J0qCrPtBX4dr
         XyEFxDF3rI4Skd8uu+tW37bMnIbIfeVll6YP9QPsiv1m3u9UI7Hz50C/EOmQGDDvJxjt
         MNnpf3ALOQX+wn100d4q49rWpqL/dLYkEvAbPydL+TGXqu4wUlet2YAblmsMtkne7qnv
         mFnrVk537e3SRZLOSIfp5DZTMcRh1T3I7huUyEOh7iplVBe4IuwO1byLK+LTz8AIzALW
         g8HnTvBYEWL7IAty6Tx+yooX0qDMEelsrde2cgdpkGApf9pCWxxWG6Loqrv6o3ZIrYoi
         o0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YQ2SYzDjclp6+UMcXfMKe/dCfkknHxuiGOrHRSVn0cA=;
        b=cYZ8QoMzoi0kleRFyNaIXyRuMkwu9EmOHn7GPLOWAGvJ0WQ5kPqZ5f4TIMfbdSiRcy
         dyA7vkF78Nbs47zic+IrQP0BtSYo1BSHnceQ4+E5nXQhDqyNypIT2t57w54Qn0JFH/pv
         vb8osql+SHw/bZPivnerkJpEmi+o7wH75XFZr5lBFmrvp7JgqD5o/5ksam0Fp4KfdEPL
         tmxs7fF0Ct0QhnRaiX+EI+XJPD0kZ5OVRk+VTTE/PjNbsOdIeqOG2zE0L6t8O/6M6Aut
         kD0DmjBodtSh9qM8VpwRFfeoxbiBmglQ7kK2gKNpGF1vKexJ9e5eJN4az3Pbxhskg1e6
         6vuA==
X-Gm-Message-State: APjAAAUNnXdJIFUiDtWp2zNXH82kKmf8R69lsziWGzBZCEz6OrexIVMO
        XRiXE2UldIkzH+7LcIBGZi5fIw==
X-Google-Smtp-Source: APXvYqwmyNu50+FxrTO6V6IulFup1S67xnT8cj+dbepaT4niD1qSPIKhFvBy+c/p26nJk53uezcFig==
X-Received: by 2002:a63:ad0d:: with SMTP id g13mr26250877pgf.407.1571675706632;
        Mon, 21 Oct 2019 09:35:06 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id e4sm16610297pff.22.2019.10.21.09.35.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Oct 2019 09:35:05 -0700 (PDT)
Subject: Re: [PATCH 5/5] ionic: Use debugfs_create_bool() to export bool
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        =?UTF-8?Q?Breno_Leit=c3=a3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        David@rox.of.borg, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Casey Leedom <leedom@chelsio.com>,
        Pensando Drivers <drivers@pensando.io>,
        Kevin Hilman <khilman@kernel.org>, Nishanth Menon <nm@ti.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191021145149.31657-1-geert+renesas@glider.be>
 <20191021145149.31657-6-geert+renesas@glider.be>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <aeebbd5f-6100-2780-ef1c-6b1c261c9d23@pensando.io>
Date:   Mon, 21 Oct 2019 09:35:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191021145149.31657-6-geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/19 7:51 AM, Geert Uytterhoeven wrote:
> Currently bool ionic_cq.done_color is exported using
> debugfs_create_u8(), which requires a cast, preventing further compiler
> checks.
>
> Fix this by switching to debugfs_create_bool(), and dropping the cast.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Shannon Nelson <snelson@pensando.io>

> ---
>   drivers/net/ethernet/pensando/ionic/ionic_debugfs.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
> index bc03cecf80cc9eb4..5beba915f69d12dd 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
> @@ -170,8 +170,7 @@ void ionic_debugfs_add_qcq(struct ionic_lif *lif, struct ionic_qcq *qcq)
>   	debugfs_create_x64("base_pa", 0400, cq_dentry, &cq->base_pa);
>   	debugfs_create_u32("num_descs", 0400, cq_dentry, &cq->num_descs);
>   	debugfs_create_u32("desc_size", 0400, cq_dentry, &cq->desc_size);
> -	debugfs_create_u8("done_color", 0400, cq_dentry,
> -			  (u8 *)&cq->done_color);
> +	debugfs_create_bool("done_color", 0400, cq_dentry, &cq->done_color);
>   
>   	debugfs_create_file("tail", 0400, cq_dentry, cq, &cq_tail_fops);
>   

