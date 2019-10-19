Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4283DDAA1
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 21:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbfJSTSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 15:18:03 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:36432 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfJSTSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 15:18:03 -0400
Received: by mail-wm1-f44.google.com with SMTP id m18so9064800wmc.1
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 12:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wGPDkx8NQ2qx1XH872MFVywREQCvij/0OKb3WNeWo84=;
        b=qQKdthK7PAne2X5U9XDMBe1UCsZf96RehSaB3fjTTimrUpy8MBEwc14iwCotTxV9x/
         ajDqdz0ekA0NuukVMAyM8jh5QJkalX6DF6gtXUcitpt2oPRy/TiKsqdwr2b+DZw4IxWL
         T33a7aFfpInv0P6GqHHavPT5ZV3d/NJ9Q1ElciSp+87gM01U4NmbxyEGjTDsNtnPz7mC
         KrEVO3p8uHcoE5LgCBSZZVzakksb9y9hoJzCe/btzgTgUEDBjWnHAIhvPnMkNhwWsTCG
         vkYDxMF6OhTYZOWEDOSgzwQtL4Vy0/eFIIAZtTeVTob/b8KBKTmJUZMmW+BywI4z++TM
         LkmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wGPDkx8NQ2qx1XH872MFVywREQCvij/0OKb3WNeWo84=;
        b=pWErfW9wPmrcUfof8w7W7uuHNPFZA63e/q1TPntMq5a18o8+RgRb+fZ7ajvmXG8ZF+
         eWwM5GnIsnW0Lv1fWRZhbcKossHkUnVD18YRbgCeS/a0TNFADXCI/wF5+8SWN139pv2O
         Y9jSayuNClzBc2YwFrZN3RSpNRTm19+2nGlMCPXJId3Py+s06Py/GhqWplmVO2grSFnr
         AloEAC/MjPT8fbshpCdKghIhkMNQeOXxYWcKa6cg+4Z+wfQa+bxFjEfKRm391ZSUZ2uW
         zFOkdCjoj1ob0xRp4rXk0eiTDTdStQneQTXfGpC+sqxpARxOSetsbJphuUoznWeJnVyk
         AFSA==
X-Gm-Message-State: APjAAAUhg9yj5S86GLDD25ySp+Oa3+tslx+EB1oWvBM1Jn8aHoGwhSAL
        dVA2tmrsmn6BPCHqF1FMmSEgCbF115Y=
X-Google-Smtp-Source: APXvYqxTbovruZt7x36AKD7I5sp/9qhG9qfi50gR12qOmw3ZPhBGHqZQavcwIqpu8uWwVtr9MFzf8A==
X-Received: by 2002:a1c:2d88:: with SMTP id t130mr12515943wmt.75.1571512681209;
        Sat, 19 Oct 2019 12:18:01 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id t4sm8486165wrm.13.2019.10.19.12.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 12:18:00 -0700 (PDT)
Date:   Sat, 19 Oct 2019 21:18:00 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/sched: act_police: re-use tcf_tm_dump()
Message-ID: <20191019191800.GM2185@nanopsycho>
References: <8f87292222c28f9b497bbd1f192045b57b38ce72.1571503698.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f87292222c28f9b497bbd1f192045b57b38ce72.1571503698.git.dcaratti@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Oct 19, 2019 at 06:49:32PM CEST, dcaratti@redhat.com wrote:
>Use tcf_tm_dump(), instead of an open coded variant (no functional change
>in this patch).
>
>Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
