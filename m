Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9976B1314AD
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 16:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbgAFPRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 10:17:31 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36639 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbgAFPRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 10:17:30 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so15644484wma.1;
        Mon, 06 Jan 2020 07:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+ZCt3vLGUbMepabE5vM9KX33fxJ9htpgdPO+Fq9gHsQ=;
        b=I/S4wgGS6UeAp4yA34vb9RUdsrJpgwXPIy8A9Af3f1sV26EdrLDei6bPeEU+jDy2Rw
         0OoUMbWClzqx5INF/XTJ4kANT57IirBh28yM5ShsHqtCCvP9c/w0VHeMhliZ9ij8Wk+Y
         Uy54HjFDkpjORe+aKwJRIHjVD5VsgQeQ2Pvqy2Tu946U6QymKWnfbt87Twslgsg3FqAi
         lCCMQe6u93Z/GD1dy8+Vfh/yutG9GwV8N6yNB6NC2jrsib+XB4g7AzW5LkOWaP+1a+Y4
         brAloH/YLKCwd/AgWeUdyDUmNpzXnyZOpuPfAUKFiTgWJFoad7jNNyaLa3EDVd43JuXz
         r+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+ZCt3vLGUbMepabE5vM9KX33fxJ9htpgdPO+Fq9gHsQ=;
        b=kU1Do8PQ4imW/JQQHYtcn/yJsOHT0nv0Nj3WZ5aEgZp6m0+iaIoXhy+HDKOrHQWoaB
         2taP6iKyq9z79Y3HRpMu7Ot34e5hVe6fNbfVhs2g2kQAsV37Qm5y2MMmvXj7/bcWHXaO
         QLC9yuxytk7br6DfU2MOCVC/12kWFAdVNCMeOX67ysGUA3uZskAr5RwDyPWhSrCt8GUV
         m75N3kFghaMsdwA4MHW/TWw4HS4sjcYMETKfQm0Im4D4xbwOe5FqOxBmIyM56B7iXPx1
         lZ9GNsvzg/0OzJY2fuqlmnAIc1U7kgRk0hNoLLP8/E7BGouNvdG7X30SZnVzh/Q9XYST
         m5Dg==
X-Gm-Message-State: APjAAAW5+XCfZF3u1ZBRO2x1rPl0f+rBIIMWj646oyYOjfh+wp8Da2+p
        /FEQclRZQhW2/VILssSXq9z5sP0=
X-Google-Smtp-Source: APXvYqwf82gdECzDnq+Rcx7mXODYzhLlBtx/JrjOl6ebVlpW0d2P9QFec5ohlFJsKGTmx77zYR/y1g==
X-Received: by 2002:a1c:4454:: with SMTP id r81mr34312906wma.117.1578323848589;
        Mon, 06 Jan 2020 07:17:28 -0800 (PST)
Received: from avx2 ([46.53.249.49])
        by smtp.gmail.com with ESMTPSA id g21sm23122553wmh.17.2020.01.06.07.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 07:17:28 -0800 (PST)
Date:   Mon, 6 Jan 2020 18:17:25 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] proc: convert everything to "struct proc_ops"
Message-ID: <20200106151725.GB382@avx2>
References: <20191225172228.GA13378@avx2>
 <20191225172546.GB13378@avx2>
 <20191231150121.5b09e34205444f6c65277b73@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191231150121.5b09e34205444f6c65277b73@linux-foundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 31, 2019 at 03:01:21PM -0800, Andrew Morton wrote:
> On Wed, 25 Dec 2019 20:25:46 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > The most notable change is DEFINE_SHOW_ATTRIBUTE macro split in
> > seq_file.h.
> > 
> > Conversion rule is:
> > 
> > 	llseek		=> proc_lseek
> > 	unlocked_ioctl	=> proc_ioctl
> > 
> > 	xxx		=> proc_xxx
> > 
> > 	delete ".owner = THIS_MODULE" line
> > 
> > ...
> >
> >  drivers/staging/isdn/hysdn/hysdn_procconf.c           |   15 +-
> >  drivers/staging/isdn/hysdn/hysdn_proclog.c            |   17 +-
> 
> These seem to have disappeared in linux-next.

Excellent, the less chunks the better.
Any actual conversion can be dropped if file was deleted.
