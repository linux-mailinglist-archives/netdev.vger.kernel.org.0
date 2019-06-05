Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E67C0366FC
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfFEVub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:50:31 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35897 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbfFEVub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:50:31 -0400
Received: by mail-qt1-f195.google.com with SMTP id u12so375543qth.3;
        Wed, 05 Jun 2019 14:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WQ5JRyCDowKpl8zLlB65ZzG3/Cp1//VKS0bBza/BbT4=;
        b=e5TGtQLRuTbhUtn4I1z36JYKoYZVk3cg/VegzFa6DfJWpPOinGMCpqhcZrGX2akxbU
         ddYLF0uQQnCsvz6kjGS6xxRShYQewg1ZRwkGoC9pKF8qzAdgWKdygEFXFV4JT2hhPWkr
         Q3JzpQ0kC5lktTkoKJ7D8FH4jMdVKlmKzgODgHe1B565wYBVs9lZy7UBWDLwKCRg2yTg
         rqqiNhRiVGAKLDODJyhP+PUFn//xeilz+O1csa2JjTMfkpowPTtsxJc57T1JTZxSgr69
         kW92bplLVAAjnaeKQZymu2TVUz/KBOdNtG0p9csNEU7AaRVKL3XpCygGcdjk8oHLSRFe
         +xaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WQ5JRyCDowKpl8zLlB65ZzG3/Cp1//VKS0bBza/BbT4=;
        b=MozfhwhtYzEnqve0OOTc3Df/awUCh4+Z2AL5MsVg6VV+T3kUCMLznxVhKGr9dPpS97
         eGgnI7Qkioq0RGpUnJ7BAzaoq3NiN26CCC9oWMLZi6fYvgiBiY30kd8GdqUx9ZDOv9qu
         gOUKTCUwrHMnNOeLF6BZAZcUIHKp0bhUZdCC7TM8+jtBDe9PR3+VkhdzT6h3+GFZrvos
         1KnHl9BjHjyLjQkQVxMAOX8OVCdT/xLRNK1kU6tCp36G41PVIT4K3/cgFkSHwyMvsjRd
         LuJgsH3i6iZsqLCl9by7z85iBJCGks2majyy5y824rYnXCfgt83iEGP3ka7D8uEzPvM4
         6Hrw==
X-Gm-Message-State: APjAAAUc37hblmFSEoqzEWPTYM3ofqH4+RU1BOg9Wgwh+C7UJ6hBRY6h
        P59TyZ2sCv/mExJv1QFvLuo=
X-Google-Smtp-Source: APXvYqwUmBs+e/Uo1U55vDroOcihm98LUfZeCzfLEsnJdrDM1nK8YuSyqn5mKBipleNxACRTmDPH6g==
X-Received: by 2002:a0c:aecd:: with SMTP id n13mr35457870qvd.182.1559771429920;
        Wed, 05 Jun 2019 14:50:29 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f019:e1f5:82ba:9aab:a373:4cb8])
        by smtp.gmail.com with ESMTPSA id 1sm31407qtg.11.2019.06.05.14.50.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 05 Jun 2019 14:50:29 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 83B8BC087C; Wed,  5 Jun 2019 18:50:26 -0300 (-03)
Date:   Wed, 5 Jun 2019 18:50:26 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, vyasevich@gmail.com,
        nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: sctp: drop unneeded likely() call around IS_ERR()
Message-ID: <20190605215026.GB3778@localhost.localdomain>
References: <1559768607-17439-1-git-send-email-info@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559768607-17439-1-git-send-email-info@metux.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 11:03:27PM +0200, Enrico Weigelt, metux IT consult wrote:
> From: Enrico Weigelt <info@metux.net>
> 
> IS_ERR() already calls unlikely(), so this extra unlikely() call
> around IS_ERR() is not needed.
> 
> Signed-off-by: Enrico Weigelt <info@metux.net>

Hi,

This patch overlaps with
Jun 05 Kefeng Wang     (4.4K) [PATCH net-next] net: Drop unlikely before IS_ERR(_OR_NULL)

  Marcelo
