Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E2ED0444
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 01:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbfJHXkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 19:40:35 -0400
Received: from mail-qt1-f175.google.com ([209.85.160.175]:34922 "EHLO
        mail-qt1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfJHXke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 19:40:34 -0400
Received: by mail-qt1-f175.google.com with SMTP id m15so792781qtq.2
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 16:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=zZIrPHDN/i7kpeuHDoSPKQUvuQChQ18rZiq0rQJmre8=;
        b=oqxrvc0dLThw15h8doM6bgzJz26mVIWhVAwdkWCukYOKEsQB/nFmqRR+URZ3nTJDqp
         LFwN10WcAT+I1jlEdCz/TNQ0cERHJrXjcDAr53gH139XPyEks3h33lN01hcTKOulVWwC
         01s2M2OPSXGgEEBhh9+04ClQVySI98md51nCsWv/0D9BCWTKalD2v/UeCF9W6tC8YS1T
         aJYurnCQwe1QEMBNwdMIteog1hlfbNiHIt0xJcIutuWQnz70X/Bq1Bwtagtl5F5kmXL0
         F+c60gYih8WHTGVdGArJmJePF/bRM+zICWJT7UsU3oQDHvng9KXLInXXhfH2XrJLFumr
         dNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zZIrPHDN/i7kpeuHDoSPKQUvuQChQ18rZiq0rQJmre8=;
        b=npkct0bVQu4PEc/vZkCIOYMjms5gh+q2MHh/NFaDkq+GAN9r+QHchm32H6fT4uqabP
         yfF4jOs5A0x5Qc6xsQgAG6A8MQkKSrpVUa6ZHSUPtDrxUpr0rUst2UjjwgLl1r6B9yvS
         siEzjDVxHiBoqQyWPUOP4YgrlIBoFNhhfGI8OFpujtVlSQxv7CFFsUUuWYOD54684aAk
         Qd86oZxBkHwb0YncdLf7X1G/fRdF9l6xidKy0skHGwk/whzl5UpOAHVfJN2Ha/4VlbwP
         Eyq2ZYB9UPgGqkcXj1XFsar288IUMXv6EpQRqb8G8HWb9O1p3PA0rwUwHKLJBCbIdjy3
         go0w==
X-Gm-Message-State: APjAAAUI2rPE8d1+QQw2EhJrrE1K/F82gUVOp4TpJCObzFw9m2wsJ/6z
        QE7fZrIqSVhEplrzHR8l3p21YVI9I+M=
X-Google-Smtp-Source: APXvYqz8Gn0RAnyTu4J+48RNIy8B6toWBhzGsvOwzJ0v8oSGMWYfnwykaknXC4P5nnRNviNy2c1HzA==
X-Received: by 2002:ac8:363b:: with SMTP id m56mr640653qtb.22.1570578032750;
        Tue, 08 Oct 2019 16:40:32 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l3sm316685qtc.33.2019.10.08.16.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 16:40:32 -0700 (PDT)
Date:   Tue, 8 Oct 2019 16:40:22 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [Patch net] net_sched: fix backward compatibility for
 TCA_ACT_KIND
Message-ID: <20191008164022.2317271e@cakuba.netronome.com>
In-Reply-To: <20191007202629.32462-2-xiyou.wangcong@gmail.com>
References: <20191007202629.32462-2-xiyou.wangcong@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Oct 2019 13:26:29 -0700, Cong Wang wrote:
> For TCA_ACT_KIND, we have to keep the backward compatibility too,
> and rely on nla_strlcpy() to check and terminate the string with
> a NUL.
> 
> Note for TC actions, nla_strcmp() is already used to compare kind
> strings, so we don't need to fix other places.
> 
> Fixes: 199ce850ce11 ("net_sched: add policy validation for action attributes")
> Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied, queued for 4.14+ as well.
