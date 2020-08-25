Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEC42523B8
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 00:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgHYWhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 18:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgHYWhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 18:37:10 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A19C061574;
        Tue, 25 Aug 2020 15:37:09 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id nv17so228608pjb.3;
        Tue, 25 Aug 2020 15:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h8BiWXKFvIak7oPavGawDbOmOCv+Pubth92AHOwlC00=;
        b=boHTh43dogQAH2Bqfwv2AXfykfHy0x+RV5X91Wvme+uBeXNlBq5si0yT4R4yZOsUq0
         AH3lxzT7SvATWjNuMg1kjKCEEFsOjKd1lgW8cq2MWgthIcn3onDVdPGYx8mLCRRxD8dh
         kIGSn7sDjz/48b6H4eof22zY3NeSMJQOr9sJLRMrfaUWu9jCrL8RbQrk41RLLHKv0LdG
         fYeIG0UVr1DHBU7HT6ANghU+yok1k+s0BdOcgUv9SD6OKdMQfsnP9P52t2o4LG0mbY48
         HdioEbfSIXJ94G8ooWpib8U3fTF5NCo89lFIyMXeTaCiEPlpQGjyxs3ZHpEpkZ4Gu1YR
         niLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h8BiWXKFvIak7oPavGawDbOmOCv+Pubth92AHOwlC00=;
        b=gQba3nRwHCIAzwVUfO80YfTS2X1v+VilANXtBwZgNOkOg76vZ2l4HXgxtHg3rgqcAp
         IBRGndilD3ZfrhbWc0bXb/w88HdajVlpda9Ij+wH56ODzvp5nAdfotdGisMBX6uOsGEK
         03xOHvzpvZnUAWcUFtR6Oq4jYemfVDiDpabXCqnOwPiIgPZB33ZOxkDvTF7Z6Z7z9tAo
         73j53jfmwjQQAUGTqVYB4gtJodX5UBawTTE5Lnwz9ktr6AAlsMHxLmIGtOJuTJheEdRQ
         t70yQkMJrvaJXo50j98s3vG/DuAJ2f7KEq9UWluIJM1325gHrEjnwc/tJe+jQlJVJpFP
         gi5A==
X-Gm-Message-State: AOAM533Ecg+v8wSV7pJZ6WOo2diFQtboa2DPIdaRuqm+JcCIYq2u967t
        o6n2peSjzkng9dAOnqnx9o0QcqZu9Ozg7g==
X-Google-Smtp-Source: ABdhPJwWo5oMcw5fIPVIufS5O3/R658R5fQL3Gpg+6QmXiHi7U5eHx/8KtfeJjSkYN1ZajgWH2mzJg==
X-Received: by 2002:a17:90b:298:: with SMTP id az24mr3536902pjb.192.1598395028675;
        Tue, 25 Aug 2020 15:37:08 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id z25sm268312pfg.150.2020.08.25.15.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 15:37:07 -0700 (PDT)
Date:   Wed, 26 Aug 2020 07:37:02 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: qlge: fix build breakage with dumping enabled
Message-ID: <20200825223702.GA24803@f3>
References: <20200821070334.738358-1-coiby.xu@gmail.com>
 <20200821083159.GA16579@f3>
 <20200825111608.2hi52kcqcdjaenki@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825111608.2hi52kcqcdjaenki@Rk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-25 19:16 +0800, Coiby Xu wrote:
[...]
> > > @@ -1630,7 +1630,7 @@ void ql_dump_wqicb(struct wqicb *wqicb)
> > >  		   (unsigned long long)le64_to_cpu(wqicb->cnsmr_idx_addr));
> > >  }
> > > 
> > > -void ql_dump_tx_ring(struct tx_ring *tx_ring)
> > > +void ql_dump_tx_ring(struct ql_adapter *qdev, struct tx_ring *tx_ring)
> > >  {
> > 
> > This can be fixed without adding another argument:
> > 	struct ql_adapter *qdev;
> > 
> > 	if (!tx_ring)
> > 		return;
> > 
> > 	qdev = tx_ring->qdev;
> > 
> > ... similar comment for the other instances.
> 
> Thank you for the simpler solution!
> 
> For QL_OB_DUMP and QL_IB_DUMP, `struct ql_adapter *qdev` can't be
> obtained via container_of. So qdev are still directly passed to these
> functions.

That's right; sorry I didn't check those functions earlier.
