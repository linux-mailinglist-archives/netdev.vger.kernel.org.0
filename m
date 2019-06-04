Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45E5234DE0
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 18:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfFDQnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 12:43:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15281 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727623AbfFDQnM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 12:43:12 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BCC9519CF89;
        Tue,  4 Jun 2019 16:43:12 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1C1460566;
        Tue,  4 Jun 2019 16:43:07 +0000 (UTC)
Date:   Tue, 4 Jun 2019 18:43:06 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     brouer@redhat.com, <netdev@vger.kernel.org>, <kernel-team@fb.com>,
        <bjorn.topel@intel.com>, <magnus.karlsson@intel.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>
Subject: Re: [PATCH v4 bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an
 xskmap
Message-ID: <20190604184306.362d9d8e@carbon>
In-Reply-To: <20190603163852.2535150-2-jonathan.lemon@gmail.com>
References: <20190603163852.2535150-1-jonathan.lemon@gmail.com>
        <20190603163852.2535150-2-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 04 Jun 2019 16:43:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jun 2019 09:38:51 -0700
Jonathan Lemon <jonathan.lemon@gmail.com> wrote:

> Currently, the AF_XDP code uses a separate map in order to
> determine if an xsk is bound to a queue.  Instead of doing this,
> have bpf_map_lookup_elem() return the queue_id, as a way of
> indicating that there is a valid entry at the map index.

Just a reminder, that once we choose a return value, there the
queue_id, then it basically becomes UAPI, and we cannot change it.

Can we somehow use BTF to allow us to extend this later?



I was also going to point out that, you cannot return a direct pointer
to queue_id, as BPF-prog side can modify this... but Daniel already
pointed this out.
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
