Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8498C7E669
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 01:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388340AbfHAXVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 19:21:46 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]:33910 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732215AbfHAXVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 19:21:46 -0400
Received: by mail-qt1-f169.google.com with SMTP id k10so2955387qtq.1
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 16:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Wa7tz5VhO8LFbM5FVlPJJLRN/NCcwt/nGW2EFsJNwtQ=;
        b=VVG7aA9UYf9laMBsRuVblyLcJ69TqRZ7HP+uglDZwjPLoITMeNSgoyjFyPqj/+U633
         4oB0hCSyG3BteADqhm+phohk/nZFE0zZ/VGBALk8LHx9ttN+WS8MPxghFmLOyI+SOW9R
         SLrSFKcLA9W1vYJIDCBhvza/ZW0WZ0awwxqliphFNhRCOe2P+dV9a7PDkwBOoMnKobGM
         LTt5jalse/xHivmBdti5s974WzhUh3kfO29/mRP8EidbO1xjG+w6gacaysxgEp0TC6hV
         4pxfELtaVMyikftOjbmdKBMkbtR6ozM6KeS6XWkoeeZpW2azGQvG2Rj8KvDNK3qqE65z
         hSug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Wa7tz5VhO8LFbM5FVlPJJLRN/NCcwt/nGW2EFsJNwtQ=;
        b=sAy99mMf9orC69jq/dCGLA6MuOS77v4uKkuR2wk5/HARm0OM1kSj6SocijSHsirZpz
         7S3Y3B+hhhCZlLSYZPaGVvGxM9OCjpMjyYUp1W0Z4U7z6opwmVj6hewiJlxcZl3arKrb
         jPsk9Ro9lsiHFxZ07qO8Yq28AfDfipsCEpk+FoP9B/SoVB7DA440U9rLxPs1liDXrrz+
         QI+6C+ENuovN5ONohIsjbK9mx3QwGLmggmWnNFvcFlPqLTMIGm8Id1MNpZgivdW4PYlc
         z8yEf0ZfH2U4zW9R/iwLGk1377zESiuSAaHeZjQcZxoYtTxnhk3FGmGWJHg2qNPx8xOn
         Cnvg==
X-Gm-Message-State: APjAAAWYi5JBoNpeKE5kGf4opQFclRLu7i5K3nXlfky61KRgsqH626Y5
        BzhvcVxXx9BiyoRFNMSsimh+IQ==
X-Google-Smtp-Source: APXvYqzWryN0OHmDbqVhykgXr1J3BDtI7mN7ytLve6Cv4egIrPmfMJj4sbOWlT09GfL6gQ61YEQypA==
X-Received: by 2002:ac8:1b30:: with SMTP id y45mr89721139qtj.218.1564701704965;
        Thu, 01 Aug 2019 16:21:44 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o22sm28806378qkk.50.2019.08.01.16.21.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 16:21:44 -0700 (PDT)
Date:   Thu, 1 Aug 2019 16:21:29 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org
Subject: Re: [v2,0/2] tools: bpftool: add net attach/detach command to
 attach XDP prog
Message-ID: <20190801162129.0a775fde@cakuba.netronome.com>
In-Reply-To: <20190801081133.13200-1-danieltimlee@gmail.com>
References: <20190801081133.13200-1-danieltimlee@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Aug 2019 17:11:31 +0900, Daniel T. Lee wrote:
> Currently, bpftool net only supports dumping progs attached on the
> interface. To attach XDP prog on interface, user must use other tool
> (eg. iproute2). By this patch, with `bpftool net attach/detach`, user
> can attach/detach XDP prog on interface.
> 
>     $ ./bpftool prog
>     ...
>     208: xdp  name xdp_prog1  tag ad822e38b629553f  gpl
>       loaded_at 2019-07-28T18:03:11+0900  uid 0
>     ...
>     $ ./bpftool net attach id 208 xdpdrv enp6s0np1
>     $ ./bpftool net
>     xdp:
>     enp6s0np1(5) driver id 208
>     ...
>     $ ./bpftool net detach xdpdrv enp6s0np1
>     $ ./bpftool net
>     xdp:
>     ...
> 
> While this patch only contains support for XDP, through `net
> attach/detach`, bpftool can further support other prog attach types.
> 
> XDP attach/detach tested on Mellanox ConnectX-4 and Netronome Agilio.

Please provide documentation for man pages, and bash completions.
