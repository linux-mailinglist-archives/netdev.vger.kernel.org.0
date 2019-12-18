Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6894F12435D
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 10:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfLRJg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 04:36:58 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23633 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726360AbfLRJg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 04:36:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576661817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R70vTqGxxvLwfS1nYWhIDXoW1oUYSYZ4nKGrNWuj2AQ=;
        b=XKj0gH4ukf3FrjnicE2Ja6l5YNLcddJ+sWcfyKXNEhEMJe74psWMnOlHBBAX9BCAIwvWvx
        uG4mK3h2AnNP7sHfeIMoYEDwhra9VqPTGEDHjv8nKOsRqX63jwBJbv/pxqeQtSZIfY3rvs
        IVdBSZlbuCvVZDQyoiB3sxyerKiQHdQ=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-HGcoUI4GNQegAmqeyLDf7w-1; Wed, 18 Dec 2019 04:36:56 -0500
X-MC-Unique: HGcoUI4GNQegAmqeyLDf7w-1
Received: by mail-lj1-f198.google.com with SMTP id y18so487765ljj.16
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 01:36:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=R70vTqGxxvLwfS1nYWhIDXoW1oUYSYZ4nKGrNWuj2AQ=;
        b=QI9z9HovgOdw/f0uzRJKxjnljaJ25j+e4REX5CAJr2k75JS7LmScq9ThuXEyuge/il
         LAqAGllsvmNigaHAfn3Jjd7cemBz1QFrNRFxsPLgNytEp24uGdYOSRid7Nk+RjOzZPdU
         XwRszcnUFiQ8KyPsnLyhGa2vt2Glb3mKnpFgmqdBTEVyMOq2ZfbLPuED/4pm0bavKxyx
         nQzNiCCSfvq6Mw3T7EvNTW75YBZfN+D+waRpgT9S1TPTlmQhw49YJ6YMpSZ1/TD9Tt6T
         7aRHTI36zHpovEouKEZx0H1u8cDKx04cQ0Bb83thgj9c1sJsiMfLhUa5t0PdAcFC1H7u
         6Pew==
X-Gm-Message-State: APjAAAU6yFaW9ietBJNGCzGvhVor0BrlgEp+FLluV3DPlj/v3dYIHTMm
        ztu+uoErUCLX0CTV5OGqC5NEYIC7OXDl98tJdnd4cjKZBHvitcDmv1631TaJiKDcXQPHPRfL+9e
        MCMDDEgd7Q5An4PJU
X-Received: by 2002:a19:c697:: with SMTP id w145mr1103452lff.54.1576661814235;
        Wed, 18 Dec 2019 01:36:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqxOKSmB5QxivN1SYVkZNEdOLTLOydUaWIcs6ed396wXkJvunbMfYr5GIRVrLCTp1negRkzylA==
X-Received: by 2002:a19:c697:: with SMTP id w145mr1103439lff.54.1576661814072;
        Wed, 18 Dec 2019 01:36:54 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id w2sm781401ljo.61.2019.12.18.01.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 01:36:53 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 95FCB180969; Wed, 18 Dec 2019 10:36:52 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [PATCH net-next v1] sch_cake: drop unused variable tin_quantum_prio
In-Reply-To: <20191217214554.27435-1-ldir@darbyshire-bryant.me.uk>
References: <20191217214554.27435-1-ldir@darbyshire-bryant.me.uk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 Dec 2019 10:36:52 +0100
Message-ID: <87k16u6kln.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
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

Thanks!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

