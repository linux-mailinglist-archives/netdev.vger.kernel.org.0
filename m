Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E858511366D
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 21:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfLDU22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 15:28:28 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37898 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbfLDU21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 15:28:27 -0500
Received: by mail-pf1-f194.google.com with SMTP id x185so395814pfc.5
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 12:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eUEvniZ1gWo3xf/PZKJ6V6k4JByoz6HYfiQVlH65A28=;
        b=StDwvvS/AxnNDg/YNipW9a1RU/MaB+5mLzkY34P4ehOrH16TOdrQt0utdX5GgoKVnE
         XrQCYEZprbZxjmQZcD/Jtku2REYdyvm25c6tj58mlbTowpTMuQxQmm3SgN+VUlHHETtn
         vOoJtqgdW0eW6t1UUTxw4QjaZcpTZdgMKkfg+w9jOHF7QcLcqwx/wAgWmBoiV6EAG49y
         29aRpkQO4y4MNnYyLlUsdySL1FLExPMKBQXi9try36j8V/lhLr1O1Q1u7RF3jC+gTaZf
         IPwqIxGepWMd/dNTIj8Htk+ZXhxL9+brpkUbBjhJvgU7234eSqoonKXetXxkpYCRXDs5
         Jdfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eUEvniZ1gWo3xf/PZKJ6V6k4JByoz6HYfiQVlH65A28=;
        b=UNIoZ9OBOAyAYTpEk9M/+mTE6DvawNQHFWnUbnGhOvGh48fzEVIh+LLRFWG2PuhEyX
         Q+JjXLB++rgr8xABS6hioeLhyjDblMsVe4r5YlcfY7uxafgp7tYU7IxeGo8IJR+THPkN
         LyhBOUjopNbeNvl5n9d52HCSPMOhv6SarheA1SGEqkMuXyjmGdQqDQ/hcrW2YjO30mmM
         m93lzOJPJDW+nF6V19piqENN2ZXAkz7bRBmMdHGZFzSZtioAK6Ks1GymwLg+bUa76m0B
         MIw+6o2U/7vCBytetEk4So0jQQ/hCz6i3LIBHLmnuYDIio6AI0jMUzcEtkNv5me3EU//
         Krmw==
X-Gm-Message-State: APjAAAWcrWbCUd6oCJLpboE1heK15mLOlaAixd/hHDmNFOZmDBGQiwAX
        LWgjhrh6PVwfgnW4CkEv9s4Lg4oyPLE=
X-Google-Smtp-Source: APXvYqwOe7ldpXr/8dqjAF57wTJKY37nUf2NZV66aQdf026FJ77Ppf2j+SVFojlMPUNOHvmJRmHrYQ==
X-Received: by 2002:a65:66da:: with SMTP id c26mr5484909pgw.354.1575491306819;
        Wed, 04 Dec 2019 12:28:26 -0800 (PST)
Received: from Iliass-MacBook-Pro.local ([216.9.110.14])
        by smtp.gmail.com with ESMTPSA id n15sm8687936pgf.17.2019.12.04.12.28.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Dec 2019 12:28:26 -0800 (PST)
Date:   Wed, 4 Dec 2019 12:28:18 -0800
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, kernel-team@fb.com
Subject: Re: [net PATCH] xdp: obtain the mem_id mutex before trying to remove
 an entry.
Message-ID: <20191204202818.GA16934@Iliass-MacBook-Pro.local>
References: <20191203220114.1524992-1-jonathan.lemon@gmail.com>
 <20191204093240.581543f3@carbon>
 <64b28372-e203-92db-bc67-1c308334042f@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64b28372-e203-92db-bc67-1c308334042f@ti.com>
User-Agent: Mutt/1.9.5 (2018-04-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 04, 2019 at 12:07:22PM +0200, Grygorii Strashko wrote:
> 
> 
> On 04/12/2019 10:32, Jesper Dangaard Brouer wrote:
> > On Tue, 3 Dec 2019 14:01:14 -0800
> > Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > 
> > > A lockdep splat was observed when trying to remove an xdp memory
> > > model from the table since the mutex was obtained when trying to
> > > remove the entry, but not before the table walk started:
> > > 
> > > Fix the splat by obtaining the lock before starting the table walk.
> > > 
> > > Fixes: c3f812cea0d7 ("page_pool: do not release pool until inflight == 0.")
> > > Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
> > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > 
> > Have you tested if this patch fix the problem reported by Grygorii?
> > 
> > Link: https://lore.kernel.org/netdev/c2de8927-7bca-612f-cdfd-e9112fee412a@ti.com
> > 
> > Grygorii can you test this?
> 
> Thanks.
> I do not see this trace any more and networking is working after if down/up
> 
> Tested-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> 
> -- 
> Best regards,
> grygorii

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
