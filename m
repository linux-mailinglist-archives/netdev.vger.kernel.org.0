Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97F6261464
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfGGID4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:03:56 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34364 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfGGID4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:03:56 -0400
Received: by mail-wr1-f65.google.com with SMTP id u18so13824221wru.1
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 01:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qkZmtsG71ih4mS94NubBDgyYrfekkCkePaPJUCF/CWQ=;
        b=r9LsjyyRDlSXEVhK3dkvqLIFwPFAZ4zQ4Z6qTlUzcZCg7vurfC5b/BN3Kua9iSrwBZ
         hHaJMj7KzvOR6unhiOOpNUcVj70JXhMUaZMUA0qz+NL4+G7RF+NxkNa4RyJ/ZCNjNZM2
         RbJ0UkPi+HkbWnIvc2F1Vm1upw4xcul08aYulCdrMuG+tebJJWez34LEcp32GIckCNu7
         IW0POSM4/lAOd0LSLa36pCEjbvM64YbANAisAc4i/Qz7ez1FKHztJO5APvimlEYfg9/P
         yJW3eP/QBcOl0P3/8pzl1lOs4Klj533WLzIhCMy9YLayM90KxWpDTeOmY1165JamYjka
         xNnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qkZmtsG71ih4mS94NubBDgyYrfekkCkePaPJUCF/CWQ=;
        b=s6LTiXZY4tixu9qz2n5q9c6IADOU5NwYcKX0hmv1K60Uf85BjaEg33dNg7J/g3uKjQ
         /PuAQykrXJUmYoab0krd/+OsS5bvWNJX+SnRCnqgDiY3++MGap+Voz/Wlzri/jd7SPDu
         F/yweSqpdeep1kW8fT7MmZmj6ZQccVRXp8GidFlS3W5x5Nx/X5Lx8Bq7sipBZlfDJMHs
         u95iuYjC1SZMzSx4qfj9Ry+QKnemiR+bErdbFF/cjqCpujKp45P9FC5Po12mtCXuJktd
         c7RK2llEeR5gIOiwtcBiAhxdvMyHHkPiNzL4fPcjo8vZyaJCkQDaZbS2QyXsQZhPIjRf
         zBXQ==
X-Gm-Message-State: APjAAAXQKfy0ecwhhkzJGa5LzbUfzFgstwxo84ZJyo7mpYQUNHFCFbcW
        Pt0VwiwCuNhP2lU0sNw0dw==
X-Google-Smtp-Source: APXvYqze0sSv+Q+dTynZFjoGtCOodov9cAnkW5DMR0wjilTeQ5SO4SFWvzhyqO3ut+Gn8oWI7FQWZw==
X-Received: by 2002:adf:f904:: with SMTP id b4mr12982627wrr.291.1562486634070;
        Sun, 07 Jul 2019 01:03:54 -0700 (PDT)
Received: from avx2 ([46.53.251.222])
        by smtp.gmail.com with ESMTPSA id y16sm13634202wru.28.2019.07.07.01.03.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Jul 2019 01:03:53 -0700 (PDT)
Date:   Sun, 7 Jul 2019 11:03:51 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Per.Hallsmark@windriver.com
Subject: Re: [PATCH 1/2] proc: revalidate directories created with
 proc_net_mkdir()
Message-ID: <20190707080351.GA6236@avx2>
References: <20190706165201.GA10550@avx2>
 <20190707010317.GR17978@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190707010317.GR17978@ZenIV.linux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 07, 2019 at 02:03:20AM +0100, Al Viro wrote:
> On Sat, Jul 06, 2019 at 07:52:02PM +0300, Alexey Dobriyan wrote:
> > +struct proc_dir_entry *_proc_mkdir(const char *name, umode_t mode,
> > +				   struct proc_dir_entry **parent, void *data)
> 
> 	Two underscores, please...

Second underscore is more typing, I never understood it.

> > +	parent->nlink++;
> > +	pde = proc_register(parent, pde);
> > +	if (!pde)
> > +		parent->nlink++;
> 
> 	Really?

And ->nlink is a separate bug.
