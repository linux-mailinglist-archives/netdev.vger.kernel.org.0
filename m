Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDBC3124990
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfLRO1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:27:48 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31813 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727114AbfLRO1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 09:27:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576679267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yh6u7qehdv2ZrOLgiyB9GH1AruwGAr6W+J6nwdB3Bck=;
        b=fCHDmFiiROIT1Rl3HAtIJo7YsJAdXM0XplPDML0qJj/3Lc1uAL/2KyuIhEa//62GVwytF5
        lmS+hnKGIPE1PASrHXwNxC2F/y3AWYjKmm2IM0bSXCGS2r0ceuRQwQtZVVEVEvAibqs6aC
        F4MCwzaqpGCprmJo2AUO/PN4tiBSZXA=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-s7oCoPJPNhquv5_IeCM9jQ-1; Wed, 18 Dec 2019 09:27:43 -0500
X-MC-Unique: s7oCoPJPNhquv5_IeCM9jQ-1
Received: by mail-lf1-f71.google.com with SMTP id t74so233865lff.8
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 06:27:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=yh6u7qehdv2ZrOLgiyB9GH1AruwGAr6W+J6nwdB3Bck=;
        b=j1vxKJEidGx/hhTyhzU2XXneV3tdgFJmDTkQvZgrUqfxx8K/WMiLJHrOGmQEqHNX93
         HcHjSkx4lwEdD70byvovsNOiunrTJ2q9HYde9IgP7tH8A9TNnWiw07tHk8KB2J8nohxT
         tZs/pz2Trf2iZZvH4naNXRgNhOdRX6d50+V12yBlvJuSN5UgTKrtphtRoVb8tr4iu6Hf
         NAxFhhZQH5pM6oGyh+VcYRrw8W7K1qZ1k7jdeznbEFUhfQamrlSoC+lrD7W/Xn6BIKEU
         kWExXD6/wDUryrtexO7j9ehDOHHkoeWWuSs/tE8b0lqXJP9rNtrun4tHgXd8zIsQT852
         rJbA==
X-Gm-Message-State: APjAAAVWHDCCUBmOfn6RbhLYAsXISJDvY+wOORCF115sM9v4kz9rdxt6
        T8xECnGYWxyTaIfqIfVvy0JvqzbYGfOiPrRxBektPjT9GFHRCXv34FvbiEWbA9kETJvF23cg3ZH
        /WtF9bNdeCsCEV4Eb
X-Received: by 2002:a19:5013:: with SMTP id e19mr1985447lfb.8.1576679262147;
        Wed, 18 Dec 2019 06:27:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqzB+U+n1lzpRsEV0dP+3lGncWmiv0iy8P0m0b14pPUg1oMXWrK7FZ0twq0HtBg1P5vmVDlSRQ==
X-Received: by 2002:a19:5013:: with SMTP id e19mr1985432lfb.8.1576679261835;
        Wed, 18 Dec 2019 06:27:41 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 204sm1230166lfj.47.2019.12.18.06.27.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 06:27:41 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A842F180969; Wed, 18 Dec 2019 15:27:40 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [PATCH net-next v1] sch_cake: drop unused variable tin_quantum_prio
In-Reply-To: <20191217214554.27435-1-ldir@darbyshire-bryant.me.uk>
References: <20191217214554.27435-1-ldir@darbyshire-bryant.me.uk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 Dec 2019 15:27:40 +0100
Message-ID: <87woat4skj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk> writes:

> Turns out tin_quantum_prio isn't used anymore and is a leftover from a
> previous implementation of diffserv tins.  Since the variable isn't used
> in any calculations it can be eliminated.
>
> Drop variable and places where it was set.
>
> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>

Just to make sure this shows up in patchwork: Dave, please drop this
version in favour of v2...

-Toke

