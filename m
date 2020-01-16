Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B0D13DE7B
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 16:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgAPPTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 10:19:35 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29025 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726189AbgAPPTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 10:19:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579187973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xOLT+/1UXIdWWF7gEPJAwJZur3tvblVQE+iNEzhcMy4=;
        b=NCipZ7d8vadWo6xk0S2QED6phoGyXh5VLNQ3IRIlJzYlqzlM7GzKoyi88ErbQLtYyWfqrC
        TrKjkd48YwQ0gq/iCEBWFDhRXKwZfoSmFj66Z9mqOWNCjjZtqx7328f4okL9CnM11ZlYH8
        hb0+rv26n2i/t2HlHZoYEbso1hKrTTM=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-g3-eebQTOCep6d_KUpf3Dg-1; Thu, 16 Jan 2020 10:19:32 -0500
X-MC-Unique: g3-eebQTOCep6d_KUpf3Dg-1
Received: by mail-lj1-f200.google.com with SMTP id m1so5262820lji.5
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 07:19:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xOLT+/1UXIdWWF7gEPJAwJZur3tvblVQE+iNEzhcMy4=;
        b=BVijoOUxHjaqnhgsqa48Nin1dudlBjpsSbAc4NLBbhsmsWmr/bDt8DLDIDFxF5OfD8
         ukclq61Wupe8lD9ANdwp2IdxCL2mxwBfTheOoJWf5AVbHIORTqzZCRR/Vms1n0ohAQD7
         pDSZpitLHKTbd6+9ILufuWymW0hkZlko83483Xxn320MNJjgkYk+w6xzZqaN4uW3QB96
         0EJAtMtNKOhLd+cMuFwLw6j6EN19iBIBXrIO5xf+kaXTshrEffce9cM3uf3JPfBZK42p
         ouB0oYYXg49jcqRGeMNQMpFnShTrkcYc+yvJpMu8Z8el3SI6bdnYhyntgnxlM6iOhbT4
         GDJg==
X-Gm-Message-State: APjAAAXJCA4fXEbXbbLhw7/I4tKdZ+UyAVfNHknPcF+KpO75hV3LrfBV
        gudlpJqlTTHJ116QQRJ66ow1hkXyb2v/sQrCuXHXN1EY4dVgy+0X+JhoM1bWNWcRqmSTudIDCbq
        nXf7v+3zQBNcfbagM
X-Received: by 2002:a2e:965a:: with SMTP id z26mr152350ljh.104.1579187970485;
        Thu, 16 Jan 2020 07:19:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqxTyVUEuAwB3Ol87GzjoUhzFRZCLV6oYpekRyHrM1JUXNJv0RIw2D1X7ZpJVrmmNNQPhiDIVw==
X-Received: by 2002:a2e:965a:: with SMTP id z26mr152347ljh.104.1579187970372;
        Thu, 16 Jan 2020 07:19:30 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l7sm10579991lfc.80.2020.01.16.07.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 07:19:29 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 163E11804D8; Thu, 16 Jan 2020 16:19:29 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net-next] netlink: make getters tolerate NULL nla arg
In-Reply-To: <20200116145522.28803-1-fw@strlen.de>
References: <20200116145522.28803-1-fw@strlen.de>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 16 Jan 2020 16:19:29 +0100
Message-ID: <87eevzsa2m.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Westphal <fw@strlen.de> writes:

> One recurring bug pattern triggered by syzbot is NULL dereference in
> netlink code paths due to a missing "tb[NL_ARG_FOO] != NULL" test.
>
> At least some of these missing checks would not have crashed the kernel if
> the various nla_get_XXX helpers would return 0 in case of missing arg.

Won't this risk just papering over the issue and lead to subtly wrong
behaviour instead? At least a crash is somewhat visible :)

-Toke

