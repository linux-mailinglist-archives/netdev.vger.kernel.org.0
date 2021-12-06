Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8235646A8C8
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 21:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349820AbhLFUu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 15:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238973AbhLFUu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 15:50:58 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B944C061746;
        Mon,  6 Dec 2021 12:47:29 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id y16so14505911ioc.8;
        Mon, 06 Dec 2021 12:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=I1j4l6JJAiArBBcQQdaAOFz5tKrvVrjdkmOCMZ3ta4M=;
        b=b+PZw9LQIT6kWHMtI9LHHPR5cDrQYm18zPoWaHgbEELTHIWwvt7Yfku2ryk0FHdkLF
         m7ZIcu5BRmeH2a5yvGJPFStbYyHHY3scVpMqDnc69G0k85Qp2sIAcXmOiqjafvzJoybP
         WC3DL7tgrFAzxmon6Ft+SVLKBj7Jjbkke+jbacs4nS3SewECt3ma1BukRVn7YhjvxIJ2
         5VqOMyVcB9el7F/Hm4P9xybziD2OfjDbhaCpVK69lLbEOWejJeHW6K3hyqeanpNh0KSq
         wEWWbr8yPD9EM42le/B1zGGzj68kzqS/Wfg1FElLD3vnnrHMA5I16UFrg7uoanPoZneM
         gWIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=I1j4l6JJAiArBBcQQdaAOFz5tKrvVrjdkmOCMZ3ta4M=;
        b=55jCe9/b/ur/OdcEUc+1p2fJakDLmaog96Je5gYyDmRhiSWvxe9Phsw1wCDJEWxQqP
         w4pdgdmg96OWvqBqybjt8rYU8LUFCTG+xm0I7e+QeHrKG18EgKvHyiiU5XOIMiWglSs3
         e2h+5waXwb5gbPSYfrOJQ309EOa9ohrfUmS4EVzK4x7HbvcWQq7SId7lH+sPbyxw98+0
         b+5QBaHnt8wPvKc/cwVQyQlOMCD9Lvy5n88cOl8r6O10s5f7RdG7R2Op7+D0nZtbFJKE
         DKno85uEThxUNe/W+pp6oVpd1/LTkq/1l/z5wdqtwdwmfUCMsJPX7MJ2ZdjdLfqC+PzH
         h7dw==
X-Gm-Message-State: AOAM531JiE3Dha3jXfQ+GslDv+/MHgfun8llDgVJg79EF3dxUrcsDnc8
        +al6X2JeqoPmY5IizXCCF7XPudscJVbL1Kbh
X-Google-Smtp-Source: ABdhPJz69onW9Go4Fhlw2O4sfbjKelNnptiWZ9DgnHlr9IU/08u/ojwxcdEwAlNp9XDT0GvuPvFkbw==
X-Received: by 2002:a05:6638:25c8:: with SMTP id u8mr47138703jat.23.1638823649063;
        Mon, 06 Dec 2021 12:47:29 -0800 (PST)
Received: from localhost ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id x7sm7087812ilq.86.2021.12.06.12.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 12:47:28 -0800 (PST)
Date:   Mon, 06 Dec 2021 12:47:20 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <61ae76d882a48_106e020844@john.notmuch>
In-Reply-To: <Ya5rFFqzXy5adxbs@lore-desk>
References: <cover.1638272238.git.lorenzo@kernel.org>
 <81319e52462c07361dbf99b9ec1748b41cdcf9fa.1638272238.git.lorenzo@kernel.org>
 <61ad94bde1ea6_50c22081e@john.notmuch>
 <Ya4nI6DKPmGOpfMf@lore-desk>
 <61ae458a58d73_88182082b@john.notmuch>
 <Ya5rFFqzXy5adxbs@lore-desk>
Subject: Re: [PATCH v19 bpf-next 12/23] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> > Lorenzo Bianconi wrote:
> > > > Lorenzo Bianconi wrote:
> > > > > From: Eelco Chaudron <echaudro@redhat.com>
> > > > > 
> > > > > This change adds support for tail growing and shrinking for XDP multi-buff.
> > > > > 
> > > > > When called on a multi-buffer packet with a grow request, it will work
> > > > > on the last fragment of the packet. So the maximum grow size is the
> > > > > last fragments tailroom, i.e. no new buffer will be allocated.
> > > > > A XDP mb capable driver is expected to set frag_size in xdp_rxq_info data
> > > > > structure to notify the XDP core the fragment size. frag_size set to 0 is
> > > > > interpreted by the XDP core as tail growing is not allowed.
> > > > > Introduce __xdp_rxq_info_reg utility routine to initialize frag_size field.
> > > > > 
> > > > > When shrinking, it will work from the last fragment, all the way down to
> > > > > the base buffer depending on the shrinking size. It's important to mention
> > > > > that once you shrink down the fragment(s) are freed, so you can not grow
> > > > > again to the original size.
> > > > > 
> > > > > Acked-by: Jakub Kicinski <kuba@kernel.org>
> > > > > Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

[...]

> > Then later there is the check 'if (unlikely(offset > 0) { ...}', but that
> > wont hit this case and we shrunk it back to a single frag. Did we want
> > to clear the mb in this case? I'm not seeing how it harms things to have
> > the mb bit set just trying to follow code here.
> 
> If I followed correctly your example, we will have sinfo->nr_frags = 1 at the
> end of the processing (since the first fragment has 2k size), right?
> If so mb bit must be set to 1. Am I missing something?
> Re-looking at the code I guess we should clear mb bit using sinfo->nr_frags
> instead:
> 
> 	if (!sinfo->nr_frags)
> 		xdp_buff_clear_mb(xdp);
> 
> Agree?

Agree that is more correct. I maybe messed up my example a bit, but I think
checking nr_frags clears it up.

Thanks,
John

> 
> Regards,
> Lorenzo
