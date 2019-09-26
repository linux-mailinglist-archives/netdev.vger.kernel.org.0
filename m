Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B09BF132
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 13:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfIZLXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 07:23:44 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54322 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725787AbfIZLXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 07:23:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569497023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=RNd7iyl5zD3WAVj2sWBbz2iZKaZZld288UAKSsgCxlk=;
        b=X1H9+C//O/1CF96zaHry/DpH9FWP1bKg6QAj8b+nJIF5dziMC7j03AJZeIf2JadbrQlgp2
        j4Ng05yxG+0zLEAczTLb7mWlEK3SC5kEC1dm1734nPboukCHR4Oc9I/u1Eplo605bOldkD
        UHALr98efN0jiCn/t5MseuO/l+x4Sek=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-ILZlbPAOMUmJ5yl85tMS4w-1; Thu, 26 Sep 2019 07:23:42 -0400
Received: by mail-ed1-f72.google.com with SMTP id l5so1134159edr.10
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 04:23:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=RNd7iyl5zD3WAVj2sWBbz2iZKaZZld288UAKSsgCxlk=;
        b=LmVXOBqhzWVdcQNzqNoYhhTpfrNWIoR032PI0AyeU6zIrcMvvWArdbDIYimudRs+Tc
         HySvs9iPnTp9O1VapwMWRw06KUrSUMuS4FO/pRPtXizhvZcj+yRmwK/1G4lXDd/9j+/q
         /UPqBNgtdF15P8WfmhTOBmUSAS9MEJ6R4q/WHC9nm41scQHH7ewUuJeEBAUUlscoclE7
         DkU2oWQxqdIXlxjZDl9zS0JtgxfR8lc++9XzNVXT7gcxIzLFQ0umb4LaAmC17/6rewVZ
         IRnYAjXRSlJmO1kpQLJcGg/VIi1JUyM5eq74VhPESueAxCH0g4Uz9dcYXbyPvptOOk8P
         NkAw==
X-Gm-Message-State: APjAAAWs/9F2KCZDwvcAIJ6eaTakhycHeg4Qozf2AZCKxaU1HC8Cgnxq
        pfoIDQzQI9IMgdCbrhXgVtWvnGrJuNhND0/EnMdgIYUkOJFB7Xv6vWCJ9WrTUKUx5uYH4oKhFXr
        UKbCZy/0dWzhkCfh0
X-Received: by 2002:a17:906:1941:: with SMTP id b1mr2499496eje.141.1569497020682;
        Thu, 26 Sep 2019 04:23:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwnmHU7Pe4fZknsumAAwCS9kWPgsn7D6xQuxdKuOxWv9QofZpL15PlmzctUYEylYBPT1hFFYg==
X-Received: by 2002:a17:906:1941:: with SMTP id b1mr2499484eje.141.1569497020443;
        Thu, 26 Sep 2019 04:23:40 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id g15sm414861edp.0.2019.09.26.04.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 04:23:39 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D09B818063D; Thu, 26 Sep 2019 13:23:38 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Are BPF tail calls only supposed to work with pinned maps?
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 26 Sep 2019 13:23:38 +0200
Message-ID: <874l0z2tdx.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: ILZlbPAOMUmJ5yl85tMS4w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel

While working on a prototype of the XDP chain call feature, I ran into
some strange behaviour with tail calls: If I create a userspace program
that loads two XDP programs, one of which tail calls the other, the tail
call map would appear to be empty even though the userspace program
populates it as part of the program loading.

I eventually tracked this down to this commit:
c9da161c6517 ("bpf: fix clearing on persistent program array maps")

Which clears PROG_ARRAY maps whenever the last uref to it disappears
(which it does when my loader exits after attaching the XDP program).

This effectively means that tail calls only work if the PROG_ARRAY map
is pinned (or the process creating it keeps running). And as far as I
can tell, the inner_map reference in bpf_map_fd_get_ptr() doesn't bump
the uref either, so presumably if one were to create a map-in-map
construct with tail call pointer in the inner map(s), each inner map
would also need to be pinned (haven't tested this case)?

Is this really how things are supposed to work? From an XDP use case PoV
this seems somewhat surprising...

Or am I missing something obvious here?

-Toke

