Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F1D1C6BE6
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgEFIh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:37:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25514 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727956AbgEFIh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:37:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588754275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=isTPirqR/XYh3iR61WK5j5e33CIaCCkNeFTS1LNebYU=;
        b=HQM3/aFDU/iE+J0/gLCEXo+YqDnx0akIaKdrCmr7kepV+4uWYX3TTLC+AlB0TljSsZ7umh
        C8SP+cMRhWSmFO1cPy3K9Be+mtU1B1djS2Y7EuTniSdkxkbEvwETXSlJAXow6WM/7K+BQO
        5tI9zwiwndD89FXW/+wjhLvh3SRAujk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-j3B4EDFvNmqfiTg9EvtdhA-1; Wed, 06 May 2020 04:37:53 -0400
X-MC-Unique: j3B4EDFvNmqfiTg9EvtdhA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 229DB107ACF9;
        Wed,  6 May 2020 08:37:52 +0000 (UTC)
Received: from [10.72.13.165] (ovpn-13-165.pek2.redhat.com [10.72.13.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B21160BF4;
        Wed,  6 May 2020 08:37:42 +0000 (UTC)
Subject: Re: performance bug in virtio net xdp
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eugenio Perez Martin <eperezma@redhat.com>
References: <20200506035704-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7d801479-5572-0031-b306-a735ca4ce0e4@redhat.com>
Date:   Wed, 6 May 2020 16:37:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200506035704-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/6 =E4=B8=8B=E5=8D=884:08, Michael S. Tsirkin wrote:
> So for mergeable bufs, we use ewma machinery to guess the correct buffe=
r
> size. If we don't guess correctly, XDP has to do aggressive copies.
>
> Problem is, xdp paths do not update the ewma at all, except
> sometimes with XDP_PASS. So whatever we happen to have
> before we attach XDP, will mostly stay around.


It looks ok to me since we always use PAGE_SIZE when XDP is enabled in=20
get_mergeable_buf_len()?

Thanks


>
> The fix is probably to update ewma unconditionally.
>

