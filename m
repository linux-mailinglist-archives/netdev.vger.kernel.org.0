Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE65173825
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 14:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgB1NSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 08:18:36 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59306 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725906AbgB1NSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 08:18:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582895915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sbp3c0c+fiWg6xZIsWqVxtwFyf0ATmyiM6CWKoaUcIM=;
        b=c5j9W2SFvObl3XJ0JykfPfCKJr4xUzDNg6uvYpspF/QyLJ11yVE+HmdF+flSE1BFs5BdLi
        VYT8DD2q/eBbflZqBASR0ZDJN7rRFNBypgbpDREPm0OmOtt3rK3rHld+8YkcuMTMOddTdx
        JjA9GqU9kwSX7EU2YffD9J5I/mr5q2s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-20MQCvRVMlmCCwD8M8YeFQ-1; Fri, 28 Feb 2020 08:18:30 -0500
X-MC-Unique: 20MQCvRVMlmCCwD8M8YeFQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4F8F8017CC;
        Fri, 28 Feb 2020 13:18:28 +0000 (UTC)
Received: from sandy.ghostprotocols.net (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 35F635C54A;
        Fri, 28 Feb 2020 13:18:28 +0000 (UTC)
Received: by sandy.ghostprotocols.net (Postfix, from userid 1000)
        id E9BE44AC9; Fri, 28 Feb 2020 10:18:24 -0300 (BRT)
Date:   Fri, 28 Feb 2020 10:18:24 -0300
From:   Arnaldo Carvalho de Melo <acme@redhat.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [PATCH 10/18] bpf: Re-initialize lnode in bpf_ksym_del
Message-ID: <20200228131824.GE4010@redhat.com>
References: <20200226130345.209469-1-jolsa@kernel.org>
 <20200226130345.209469-11-jolsa@kernel.org>
 <20200227195034.jq76twzwxdlfcwpd@ast-mbp>
 <20200228121708.GH5451@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228121708.GH5451@krava>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Feb 28, 2020 at 01:17:08PM +0100, Jiri Olsa escreveu:
> On Thu, Feb 27, 2020 at 11:50:36AM -0800, Alexei Starovoitov wrote:
> > On Wed, Feb 26, 2020 at 02:03:37PM +0100, Jiri Olsa wrote:
> > Do patches 16-18 strongly depend on patches 1-15 ?
> > We can take them via bpf-next tree. No problem. Just need Arnaldo's ack.
> 
> actualy there're some changes on the list from this week, that touch
> the same code, so we might need to take them through Arnaldo's code

Ravi's patches, yeah, will push them via perf/urgent now, since those
are fixes, but I guess those won't clash...
 
> I'l double check

Please
 
> > 
> > Overall looks great. All around important work.
> > Please address above and respin. I would like to land it soon.
> > 
> 
> will respin soon, thanks for review
> 
> jirka

