Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74642124573
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfLRLPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:15:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24959 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725930AbfLRLPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:15:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576667706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pDExBp6N2KqojXTPG0+Gp10QLUPfm8Ox8GErnJhVPNw=;
        b=GZKz0MYSGVP5/8MDKhHJnzAreIa3705nOhZ/TNwZ2nRdaaAMcf6p4tY/9n7cjzuFv6QvUg
        NUi4QWStMmNaxWWvnjUgyJ5ow8LKHc7A+R1itGgPSEyL6EoNBQYIKqRdxwiy1ZD+MIFo4p
        XDEASIRG52K7fCjzys7OhoQDUGRnadk=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-Y2swDBVYNJuetzuo83acqw-1; Wed, 18 Dec 2019 06:15:02 -0500
X-MC-Unique: Y2swDBVYNJuetzuo83acqw-1
Received: by mail-lf1-f72.google.com with SMTP id d7so185851lfk.9
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:15:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=pDExBp6N2KqojXTPG0+Gp10QLUPfm8Ox8GErnJhVPNw=;
        b=PH476IT9jwm7p61Vwyg6COZtTi/3R47UiocdUM0jkD4ik2pt5103sfecNshwQOCIsV
         wvXZzkW3XdXz5CPKonx1isCFrcUGumn0CjR8BBinFDjvpbl+5dbCICRCdTQKmj4dKt2H
         OjNKbgMaWTJNm0bg23jrR2R7mHbQant7mkanRx7Kwi+yd5VsJYDM/ZDctzDo8TZKURhz
         QjfhnMHzaEcgNKeC/rF+bVLHdtibm8l1lGFpZhMD1LyzP7MZXSP5+d57Wa0GgSNDlQv+
         Ch2d0//EKtnVskUvWFHWBmFcaC5Cv7yrmkAdlqeAEuKJZPgUc7/szFFJqTXi/SqoCL8F
         IH6w==
X-Gm-Message-State: APjAAAXrcnC/rD6uxJS4oQHO5NEgVz5Yur7fqLN8/CEImss3UrSwc2DJ
        zu4jFaGRnXiJ1y4cFcELLr90WFEJ2Zy0ndVoL8Y9DfqAIOzQ0cBWq0bI7j9XOo6J7ujyOMjy2L1
        Sd7/R6DyC71deQmmo
X-Received: by 2002:a2e:a408:: with SMTP id p8mr1299968ljn.145.1576667701608;
        Wed, 18 Dec 2019 03:15:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqxu/QsFi5ppTKWgJ/GsTNk/uvuIeU95JnusduZ6XHkMbBeYOQHZNK5HbKXRf+fHg9S9LJb4BA==
X-Received: by 2002:a2e:a408:: with SMTP id p8mr1299950ljn.145.1576667701304;
        Wed, 18 Dec 2019 03:15:01 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q186sm978511ljq.14.2019.12.18.03.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:15:00 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 70216180969; Wed, 18 Dec 2019 12:14:59 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: Re: [PATCH bpf-next 1/8] xdp: simplify devmap cleanup
In-Reply-To: <20191218105400.2895-2-bjorn.topel@gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com> <20191218105400.2895-2-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 Dec 2019 12:14:59 +0100
Message-ID: <8736dh7umk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> After the RCU flavor consolidation [1], call_rcu() and
> synchronize_rcu() waits for preempt-disable regions (NAPI) in addition
> to the read-side critical sections. As a result of this, the cleanup
> code in devmap can be simplified
>
> * There is no longer a need to flush in __dev_map_entry_free, since we
>   know that this has been done when the call_rcu() callback is
>   triggered.
>
> * When freeing the map, there is no need to explicitly wait for a
>   flush. It's guaranteed to be done after the synchronize_rcu() call
>   in dev_map_free(). The rcu_barrier() is still needed, so that the
>   map is not freed prior the elements.
>
> [1] https://lwn.net/Articles/777036/
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

