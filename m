Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47F7612459A
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfLRLUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:20:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50501 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726682AbfLRLUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:20:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576668000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lv2aG88TsoBY1Gtzn+rvzVvVT3dJSL+Og5VTXQp1x9s=;
        b=irgp9MLrREhSwnXLv9X5qbx9I2ql/6NmKcEfdPN0lbLkp2SeA3/pYlQl7+eawkKPDMmPIN
        d/T35ZwDwJrWhy3/POySH50Ol8fDzRkXuQacwLSV8rdcwqTAX/2Vj+VRVEI8FNuqJHo6OF
        l1SliXAB8uNiOkdEmjOP2MIduCN1/9I=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-VDw4knfaNbeSX3o_MMVocg-1; Wed, 18 Dec 2019 06:19:58 -0500
X-MC-Unique: VDw4knfaNbeSX3o_MMVocg-1
Received: by mail-lf1-f70.google.com with SMTP id 6so187066lfj.17
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:19:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=lv2aG88TsoBY1Gtzn+rvzVvVT3dJSL+Og5VTXQp1x9s=;
        b=gKFxMV0nu97/9aDYJntZ+58zK6S/DAjTUeW8C9O0d5hRXrh0mP4FPDwZYX7MvhCtDG
         R9pvsRmT2lleVWstxIYvwzcQn2VyAn3MkdcM1i2590Gj1KrUfrk3TNomcGbIwo9gganq
         gbVyNDW69qHtI81TP73Qvkx+wfim+YJszWsxs9HeMYQhGfGXz1VGeKutlEz9UhRdH7it
         buoRzHOnZfzlMWV36lEN2SUv24xKAfkp6pEyPirnAsnxnMoneQxtNv2bIGMQhMeo65gM
         nmGvIeOH4b2vYKM+UDX6e1l56aHC7Jne+lDFYEfz8jLCVSGiVJlVUZPmOVh4ffl3Xocy
         1CoQ==
X-Gm-Message-State: APjAAAVR4e4PwbeTXxKg2EJnm6u/Gmfb62h6JeONqxFO8HpA5nzM+eCg
        UpnlCJ9m21+VWsvpANqMp+vQOSEugjDocuA3m0lk/Utc+9aYM88c954Qezsq6UZhbGzPawyOlqT
        339Q6FIjJ6C8RZWLx
X-Received: by 2002:a2e:978c:: with SMTP id y12mr1168043lji.167.1576667997139;
        Wed, 18 Dec 2019 03:19:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqyjHsRTG2Z0nKVQalh7Mb+J6dmxqtTJQ2370SvMZTHE1AYkHBlJiLkPJrWqvCmhldcNKnJlHQ==
X-Received: by 2002:a2e:978c:: with SMTP id y12mr1168025lji.167.1576667997003;
        Wed, 18 Dec 2019 03:19:57 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id b20sm956994ljp.20.2019.12.18.03.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:19:56 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9B3EF180969; Wed, 18 Dec 2019 12:19:55 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: Re: [PATCH bpf-next 6/8] xdp: make cpumap flush_list common for all map instances
In-Reply-To: <20191218105400.2895-7-bjorn.topel@gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com> <20191218105400.2895-7-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 Dec 2019 12:19:55 +0100
Message-ID: <87o8w56ftw.fsf@toke.dk>
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
> The cpumap flush list is used to track entries that need to flushed
> from via the xdp_do_flush_map() function. This list used to be
> per-map, but there is really no reason for that. Instead make the
> flush list global for all devmaps, which simplifies __cpu_map_flush()
> and cpu_map_alloc().
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

