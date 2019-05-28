Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6A12CDED
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 19:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfE1RsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 13:48:10 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:37077 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727578AbfE1RsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 13:48:10 -0400
Received: by mail-lj1-f176.google.com with SMTP id h19so10158851ljj.4
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 10:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2b+zSBhPUFYF8TBcN9S0abTU+XNsI8SZLoQByKSROWg=;
        b=qX8y18Zy+GnzVQa2UigP1iRWt+eWH2IvHmgfCT3SGRK1RLT3u3ZkxEq5ulQl015/6P
         bcUK7u6Urwg/yga0aWUmCiP5HjwwCcK3HDZBnnUusAWTbUSRnskCM8K5qnGHLAYY+PrA
         u/pnUg2xKKJQ4RcCUv5FI2i4nW0K9pWMXuPllE+bBKuEHBS7oCDPM4pzYgPzhBhDJD9m
         KQW73mD4AnCgsoJ5Slg1aiDUBVeERnp6OLebxRK8m5r8o4uA3mRX7ycpaNylAoKcHs4U
         7lFasX2dOAzUNi6OAY8cPlSa3MwVIBFYDZjO5QxKDT61RGSN8CekqS0ZVu7I1iLlJAu8
         Sxhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=2b+zSBhPUFYF8TBcN9S0abTU+XNsI8SZLoQByKSROWg=;
        b=Kdr5jLVbo8kgwUUZZPRiECZefBn2Hg6vT5wbG+sUVpiT/aybei5tKu6sdGSHQ8Al2n
         J+CeLqNOZDFYcsSHgPE/iXiEESo8TC8MRI21HsAQfjc/lP+b1mB2CVjwls1XUQ2yTEZu
         EY7K27Jy2nzsDHJmH0/6pNUz4/HSDCBW+GRwX4fVwgWf2MR+S2GK8DD9B2BoquxYymJ1
         xk4espC7Cc02OA4tezVgH9TOHYBb9g4R+0RLr67ByetPOIY5S0sB+M6KtNW2CNbBC23l
         1IZqd4WXG7CAaYtOm1ZH2uwKlHFaz4oBk+XtB0FgPdVRDIj98HNn+u9u55bNnq9ZuDoF
         c4SA==
X-Gm-Message-State: APjAAAXc77FtmbfQKY7lcrdXX8v1BSCcRGvF8giVJWWb/h1nq624FUcQ
        zDCBuOAvOTY7wg5oLlhFo1VnKg==
X-Google-Smtp-Source: APXvYqzGAfNp2urKxLyPkaIXh7rQVPVPHDYGjYpJ53BFyfb2W3CmKlz169LP2vWgEVFSJtyS7SBhfw==
X-Received: by 2002:a2e:818b:: with SMTP id e11mr65623965ljg.82.1559065687568;
        Tue, 28 May 2019 10:48:07 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id j7sm3641208lji.27.2019.05.28.10.48.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 10:48:07 -0700 (PDT)
Date:   Tue, 28 May 2019 20:48:05 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com
Cc:     davem@davemloft.net, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ethernet: ti: cpsw: correct .ndo_open
 error path
Message-ID: <20190528174803.GA3233@khorivan>
Mail-Followup-To: grygorii.strashko@ti.com, davem@davemloft.net,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190528123352.21505-1-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190528123352.21505-1-ivan.khoronzhuk@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore this version, I've sent version 2 that do the same but is more
adjustable for later on changes and based on usage counter.

-- 
Regards,
Ivan Khoronzhuk
