Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41731ACC6C
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 13:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbfIHL2f convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 8 Sep 2019 07:28:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48666 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbfIHL2f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Sep 2019 07:28:35 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B8A8018C891B;
        Sun,  8 Sep 2019 11:28:34 +0000 (UTC)
Received: from carbon (ovpn-200-20.brq.redhat.com [10.40.200.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7786D5C1D4;
        Sun,  8 Sep 2019 11:28:23 +0000 (UTC)
Date:   Sun, 8 Sep 2019 13:28:22 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     brouer@redhat.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        kafai@fb.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        syzbot+4e7a85b1432052e8d6f8@syzkaller.appspotmail.com
Subject: Re: [PATCH bpf-next] xdp: Fix race in dev_map_hash_update_elem()
 when replacing element
Message-ID: <20190908132822.5ac2fbe1@carbon>
In-Reply-To: <20190908082016.17214-1-toke@redhat.com>
References: <0000000000005091a70591d3e1d9@google.com>
        <20190908082016.17214-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Sun, 08 Sep 2019 11:28:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  8 Sep 2019 09:20:16 +0100
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> syzbot found a crash in dev_map_hash_update_elem(), when replacing an
> element with a new one. Jesper correctly identified the cause of the crash
> as a race condition between the initial lookup in the map (which is done
> before taking the lock), and the removal of the old element.
> 
> Rather than just add a second lookup into the hashmap after taking the
> lock, fix this by reworking the function logic to take the lock before the
> initial lookup.
> 
> Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up devices by hashed index")
> Reported-and-tested-by: syzbot+4e7a85b1432052e8d6f8@syzkaller.appspotmail.com
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
