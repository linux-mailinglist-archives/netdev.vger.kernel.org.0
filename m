Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5ECB293104
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 00:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387970AbgJSWPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 18:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387940AbgJSWPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 18:15:49 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD06C0613CE;
        Mon, 19 Oct 2020 15:15:49 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id p88so940334qtd.12;
        Mon, 19 Oct 2020 15:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XHppFtDmgdMCJHpn5fj93tKn7yICQQvMCO0+pV7BH+U=;
        b=gY4dXZvLvlSnVrmop6pJ5uSFwjxi6S+3VQWAUBVor5pEOze90zn9bKwG27LCJ7/zoH
         rIfIVXfASsGfiP0Lf4uuqKaYlbOudvGgnNPOb3Cqf0InhiL3z9dbP8bae6OiosBWY8lv
         XDT2gpP++RjqxMY0GhbuehqyEyaWPpKMuyqiSPhT2t8ZJsukQenLcHSmqLtY45usZppy
         vWI3gVOaxrZ3kXR2q1LWvkS28F0jS3VtUgfgyDRbQeCDQ4xo2iQmm+T70BaD7i/GeiVu
         zueUVCuygMKHOichdPj8ICfeQlMK5IOBrxtDTSnr7jqnrdAWjJiw1DscDz8ol3+YF5W7
         wPtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XHppFtDmgdMCJHpn5fj93tKn7yICQQvMCO0+pV7BH+U=;
        b=lr67Vd9dqhNA2grWV8XgpuzyJ9o0nSaPFmwZtdQ9eajYDLgqM6zUl9kpg1+lD+hzEx
         WJme2Th2hMaUV7qsAgezdmDJ/NxZHt0b+iMqdiTBaIwyCFhPEbSOrAbEfrcZqjgKuiyj
         wI1zD4ExRSWJUycjdBtuuiWa6juPRPJ3wxmJ+OY+UyyrsDlXXYjf8n+2gyxpRGLP0HYJ
         dNOhvVfc/45DPYrO0MgDPC5rFJteh4CU3IYAIzPZr1GM8lDdhUBMWNmYJuDm+rPzIXGD
         6gY24mmNmQNdq1l4Mco0HEQlfe2nWh8RqTiRzCpO7W5LenPzNFN2L4KoGdZ9DLhPa8hC
         ofHQ==
X-Gm-Message-State: AOAM530FsLF1x8PKMJDfM+uTdTk4sIVBrDOOZsOvLQHjKtcyPKZouBtf
        JN5tcPpVasHBeB71paU7oNY=
X-Google-Smtp-Source: ABdhPJzNrQZxbPTA5VbseXbPUvwHUWHruJ1jCyTJatVLtHA5pmeP6FG/1Uwmj8ZxrbRa3PlCwESsdg==
X-Received: by 2002:ac8:c02:: with SMTP id k2mr1676106qti.189.1603145748203;
        Mon, 19 Oct 2020 15:15:48 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f013:5091:9c4f:6b95:2ed0:130e])
        by smtp.gmail.com with ESMTPSA id 128sm577259qkh.53.2020.10.19.15.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 15:15:47 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 4AB7FC1632; Mon, 19 Oct 2020 19:15:45 -0300 (-03)
Date:   Mon, 19 Oct 2020 19:15:45 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [PATCHv4 net-next 16/16] sctp: enable udp tunneling socks
Message-ID: <20201019221545.GD11030@localhost.localdomain>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <b65bdc11e5a17e328227676ea283cee617f973fb.1603110316.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b65bdc11e5a17e328227676ea283cee617f973fb.1603110316.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 08:25:33PM +0800, Xin Long wrote:
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -2640,6 +2640,12 @@ addr_scope_policy - INTEGER
>  
>  	Default: 1
>  
> +udp_port - INTEGER

Need to be more verbose here, and also mention the RFC.

> +	The listening port for the local UDP tunneling sock.
        , shared by all applications in the same net namespace.
> +	UDP encapsulation will be disabled when it's set to 0.

	"Note, however, that setting just this is not enough to actually
	use it. ..."

> +
> +	Default: 9899
> +
>  encap_port - INTEGER
>  	The default remote UDP encapsalution port.
>  	When UDP tunneling is enabled, this global value is used to set

When is it enabled, which conditions are needed? Maybe it can be
explained only in the one above.
