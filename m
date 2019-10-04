Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 842FBCBDDA
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389460AbfJDOtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:49:23 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33515 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388870AbfJDOtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 10:49:23 -0400
Received: by mail-lj1-f193.google.com with SMTP id a22so6839371ljd.0;
        Fri, 04 Oct 2019 07:49:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AICnQvY7QcNF7f+/M4M7hIgheGhg17w1bpamNJvqPmY=;
        b=tkFCdZAg4Bda89sCDZdt5sY+A7SR+mRB2xixkQwgQYXtIOqtianMUj9xnGc9CSwxk0
         j7CkLl4Nx4qmVBoQYiSlS1R9j6fceFFBPBEkrgmNSQZoLyUVWQkrKfINIuKZ8A+yHK5s
         xik8zoiLQR3SQO0wIP0dlqRhivoMRG6coI6yBgm7dF1jsBZ3yyEbyd2wiweMKu9vgHyb
         qIUKOi/w3czVQXQbAiDCJQZTYqPdr0P3t1bGm880P9ekuu5jNBMBeYtk6rrWhK743e/n
         rGJ9gFaH3k8H3TABiXKj9GjQ84QoFP5oVBtTyV7bSamN8UlNPBq9svgoQUo1ClxPYoIA
         98xA==
X-Gm-Message-State: APjAAAVDw8qc+Bn5SAPvNGxiMSW/966+UslxN73ZcKLalRi7sKhSLXzH
        W76PAi6JU9d+UJEXBz2bb+o=
X-Google-Smtp-Source: APXvYqxeivwiGvJSLj2qnzaww/e3vxhBx0aQeGAz7MOTp/aSTBo8DiGeHX+enW/cZawQMX4B5qQb1A==
X-Received: by 2002:a2e:9585:: with SMTP id w5mr4088615ljh.220.1570200560185;
        Fri, 04 Oct 2019 07:49:20 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id y26sm1584105ljj.90.2019.10.04.07.49.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 07:49:19 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@kernel.org>)
        id 1iGOte-0005Vp-Uy; Fri, 04 Oct 2019 16:49:31 +0200
Date:   Fri, 4 Oct 2019 16:49:30 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Denis Efremov <efremov@linux.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: Re: [PATCH] rsi: fix potential null dereference in rsi_probe()
Message-ID: <20191004144930.GC13531@localhost>
References: <20191002171811.23993-1-efremov@linux.com>
 <20191004134736.2D517619F4@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004134736.2D517619F4@smtp.codeaurora.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 01:47:36PM +0000, Kalle Valo wrote:
> Denis Efremov <efremov@linux.com> wrote:
> 
> > The id pointer can be NULL in rsi_probe().

While the existing code in rsi_probe() may lead you to believe that,
this statement is false. 

> > It is checked everywhere except
> > for the else branch in the idProduct condition. The patch adds NULL check
> > before the id dereference in the rsi_dbg() call.
> > 
> > Fixes: 54fdb318c111 ("rsi: add new device model for 9116")
> > Cc: Amitkumar Karwar <amitkarwar@gmail.com>
> > Cc: Siva Rebbagondla <siva8118@gmail.com>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Signed-off-by: Denis Efremov <efremov@linux.com>
> 
> Patch applied to wireless-drivers-next.git, thanks.
> 
> f170d44bc4ec rsi: fix potential null dereference in rsi_probe()

I just sent a revert to prevent the confusion from spreading (e.g. to
stable autosel and contributers looking for things to work on). Hope you
don't mind, Kalle.

Johan
