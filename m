Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC121AE278
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 18:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgDQQrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 12:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgDQQrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 12:47:53 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A854AC061A0C;
        Fri, 17 Apr 2020 09:47:51 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id x66so3059965qkd.9;
        Fri, 17 Apr 2020 09:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jvi5l+Cvi7+NgWuXgV5x5iR99VCJS8AvoQUrjoNh1iw=;
        b=fwAAS0Z8VVEix3VtEOuCR8z9wpk2fNcZK7Qkvt3g3XkUfLhz/kIb5d4M7u6NpWHWJA
         +bYMFMTScvLn9wjE031jSdS+wkhDzoHPy64Afx8sguBoLms/sM+Ty4laFKJ60kAXeCwz
         mMD4/ReAbq8GHpRhWugXIxemWk+iLiaiBI2bHZ3oiwwa9STBZPIjkMog8sgVq/cKAf9d
         I1SI6dig7shAOIPBVbWtWb0Ej0RC0Od3haL8GEk5/CcDpj0YVxKqxtyaypmccG0RnPBA
         5QUsbUmiVJ57IRhgC9ungYg63FWOgNXnlMa307KvzqwoCmoEk0yz+Ck/isfocLrmZHIN
         vLgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jvi5l+Cvi7+NgWuXgV5x5iR99VCJS8AvoQUrjoNh1iw=;
        b=VQrbDvJZDAkXuB8Ijh5VconkwlbqUNoQbAAKcI8Ey0tfMlYXXIO7wwTyczaUUmKj4D
         ECXnIjDBywOjcSmKwjLSk1sswCNei2+ZTXk1yfNQ9ic23OwceU7esMd5zj6cHiX6yIrm
         U2OP//LydSOGLkA8UScjCQSBNtnS4r+1/c2/YNkhj24yGYMlcFueUu0ijbm5RXIq68XP
         fqZxPDF126vdJd5zwd0Q7Oga6c2Bt5AP7n+OECIthbT/oyQpFCJb2sCu4uiqMrbq3sUr
         aO9D6vn6iYmHGgMaqwbeI5SkW59wZq8XKOoWxYF1NYl8t5DEsJMfgsiOkaiK4I8KH8Ya
         s3ng==
X-Gm-Message-State: AGi0PubfuSN9lYmdZC3QHBp7L4SJ8C44qA5eB+7V4StAhVRcSnoSF2HE
        QrkUQKz5JstDcEXH9SXEzg0=
X-Google-Smtp-Source: APiQypIGbp1/VjpCIVYUMxOaqqwFJua/la/07UT+Ab8011YYmPU3sQyokDfvSOJ697BZwJE8V4RtjA==
X-Received: by 2002:a37:508:: with SMTP id 8mr4325358qkf.265.1587142070761;
        Fri, 17 Apr 2020 09:47:50 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id k2sm17714599qte.16.2020.04.17.09.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 09:47:49 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 1FD9F409A3; Fri, 17 Apr 2020 13:47:47 -0300 (-03)
Date:   Fri, 17 Apr 2020 13:47:47 -0300
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 0/6] bpf, printk: add BTF-based type printing
Message-ID: <20200417164747.GD17973@kernel.org>
References: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Apr 17, 2020 at 11:42:34AM +0100, Alan Maguire escreveu:
> To give a flavour for what the printed-out data looks like,
> here we use pr_info() to display a struct sk_buff *.  Note
> we specify the 'N' modifier to show type field names:
> 
>   struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
> 
>   pr_info("%pTN<struct sk_buff>", skb);
> 
> ...gives us:
> 
> {{{.next=00000000c7916e9c,.prev=00000000c7916e9c,{.dev=00000000c7916e9c|.dev_scratch=0}}|.rbnode={.__rb_parent_color=0,.rb_right=00000000c7916e9c,.rb_left=00000000c7916e9c}|.list={.next=00000000c7916e9c,.prev=00000000c7916e9c}},{.sk=00000000c7916e9c|.ip_defrag_offset=0},{.tstamp=0|.skb_mstamp_ns=0},.cb=['\0'],{{._skb_refdst=0,.destructor=00000000c7916e9c}|.tcp_tsorted_anchor={.next=00000000c7916e9c,.prev=00000000c7916e9c}},._nfct=0,.len=0,.data_len=0,.mac_len=0,.hdr_len=0,.queue_mapping=0,.__cloned_offset=[],.cloned=0x0,.nohdr=0x0,.fclone=0x0,.peeked=0x0,.head_frag=0x0,.pfmemalloc=0x0,.active_extensions=0,.headers_start=[],.__pkt_type_offset=[],.pkt_type=0x0,.ignore_df=0x0,.nf_trace=0x0,.ip_summed=0x0,.ooo_okay=0x0,.l4_hash=0x0,.sw_hash=0x0,.wifi_acked_valid=0x0,.wifi_acked=0x0,.no_fcs=0x0,.encapsulation=0x0,.encap_hdr_csum=0x0,.csum_valid=0x0,.__pkt_vlan_present_offset=[],.vlan_present=0x0,.csum_complete_sw=0x0,.csum_level=0x0,.csum_not_inet=0x0,.dst_pending_co

One suggestion, to make this more compact, one could have %pTNz<struct
sk_buff>" that wouldn't print any integral type member that is zeroed
:-)
 
- Arnaldo
