Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0836CFDEA7
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 14:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfKONOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 08:14:30 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41751 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbfKONOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 08:14:30 -0500
Received: by mail-pf1-f194.google.com with SMTP id p26so6659840pfq.8;
        Fri, 15 Nov 2019 05:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vjaotZdk3GSTT95AfoQh9M1LKSx6XuqLnLrFhIfRlF8=;
        b=Xv6inqLn3tjxqPEIhT0bqA7kUI6M50KVcOE0EXlgtudqSBvx/8zvQeV82Sn8qcvPwp
         HdRCXfJhmu+AfD9OYy0BR1Fxd3kOf75EzoNS++EVexy/QXuiB/QfnayTdUugc2swWVWe
         yYtRLdDnHh5Y8KQlo6OSlCSl7nHQVnjYs7WpssCDEskTX4l+zFkO4VizUmawlgcwDnUf
         kFwAUDFpEannJ9IU98EJscwyT+ftv9ee8+QWJhn7wXTefcVqdNKFF2qkbxp1RvG+Bxos
         d7EaFiWByVtoMRGavoMYAeHhBZqMpFc6HPKF522foq7oWkcqwbIZcHjS10xEzgRkpFMO
         NMvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vjaotZdk3GSTT95AfoQh9M1LKSx6XuqLnLrFhIfRlF8=;
        b=BCvSFQxLKn1nw1bwhl41dL1iQZB8aoqRqtH3zQx+r8xbqfKWLA78tz7hzvJ/iq2o+m
         MNDkiwbFcdeaiheIapfgJ0KnHkH0MEcpGIybCycqOM0Rq+oYWDByrlC9rFP6jqQDn89o
         emmNljDDQ6w1cGhUkV48U2Ly0RhBG2VRIRc2WvTwtEnlBITIR9mdvigh6u2XjzmZ4VtQ
         ypq2jnam+ZnOpQV/eXnXRwOrq+mhaCm3Wqn+5TXufFhegO+ySE5PjalvZWYLVw6ahtQi
         HP2Wq5VjhDaqCrkdRcElAtiNvh+R93edvx6cJhohd4llEHgBV4iTptS5Go/AEw68DvDA
         NAcg==
X-Gm-Message-State: APjAAAWEY15wnmtoLKFw7WTyxo9a9Oz8u7zamKaEzOdlCgpQyVoSQrgQ
        xh7LF79DWQ1jli1qOvjRdEE=
X-Google-Smtp-Source: APXvYqwRDyFEH2e4zhdQUYBI9ZMDv4S1tacfNj9jD7sN9JQWQ8sOlpyKij2ZLBxKKRLWXm5owZlQjg==
X-Received: by 2002:a62:ac06:: with SMTP id v6mr17066728pfe.210.1573823667863;
        Fri, 15 Nov 2019 05:14:27 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:c9ae:cf0c:82df:2536])
        by smtp.googlemail.com with ESMTPSA id u3sm10360008pgp.51.2019.11.15.05.14.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 05:14:26 -0800 (PST)
Subject: Re: [PATCH] vrf: Fix possible NULL pointer oops when delete nic
To:     "wangxiaogang (F)" <wangxiaogang3@huawei.com>, dsahern@kernel.org,
        shrijeet@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hujunwei4@huawei.com, xuhanbing@huawei.com
References: <60e827cb-2bba-2b7e-55dc-651103e9905f@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fde95f03-72ee-b4e9-7f14-b98e3227f0f4@gmail.com>
Date:   Fri, 15 Nov 2019 06:14:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <60e827cb-2bba-2b7e-55dc-651103e9905f@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/19 11:22 PM, wangxiaogang (F) wrote:
> From: XiaoGang Wang <wangxiaogang3@huawei.com>
> 
> Recently we get a crash when access illegal address (0xc0),
> which will occasionally appear when deleting a physical NIC with vrf.
> 

How long have you been running this test?

I am wondering if this is fallout from the recent adjacency changes in
commits 5343da4c1742 through f3b0a18bb6cb.



