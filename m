Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445F79709E
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 05:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfHUD7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 23:59:23 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33608 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbfHUD7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 23:59:23 -0400
Received: by mail-pf1-f193.google.com with SMTP id g2so521146pfq.0
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 20:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=gL9uEZXrthrLma93xHlhhVz0u+gXVl/manNEm7zD+Hs=;
        b=JOuRnlbasYDvubZXZRGpOIXMQtegVKn3gQu3QE+fy5Lh4ogcdrcy6BmtM+2SiJ+myc
         W7SBj+7SuNix4ZHavSO/Ogk7UqN99Qd4yg3GTt0tRXdG7DNPlY5Gjh606MMOMLPF57sC
         rf3jdU4X4fx6K4dYI38rerZxicArGNJWb9rRs78f9xYcza03NJQrxUfLtJ5W0X8FNAKu
         mkaHJtSwYPco0TA8zCEx06agSMEN1bb0ZkCZOgJ1T6fS8v2yLbgVBn+giF31LnpQ/byk
         XjTqPpr76lLM5HTppAIIpIboQqFBGtZGNDB1P+qXQv8laY23DVxkHPpmmaEQHlKXw4zL
         jp+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=gL9uEZXrthrLma93xHlhhVz0u+gXVl/manNEm7zD+Hs=;
        b=ogtFe7NkZpmM0i+Y63SHUt8nu97vmx0OBK0+WbXq7lMJT66grAl8Qnh4BZvTeY4sGk
         7B3fCtQonyUOplg+QJwqVcOfKG7L7EUCd5SmwkMTZ6wefKgCop6ZF336ikToO83SRTSG
         sd+IYhm+zlbbmX1bqhUz8GCZBAw4lYlxHm9YDhqW6aMN4vPeXkbXLZO89GShDMieD/AJ
         A0eIPhMi/hwJwmuXEN8+8siIdbmSYaT0hD3NTnHDeu/E/8CUHjoPb+PCyiCd1UokmHDx
         R+tRK19dGDKi2ZMmh8/i27HvMMR9eAOJ9tr9TdLjHLZ1185b4jUhKfMqkDrS+5fFYBRx
         FH2A==
X-Gm-Message-State: APjAAAUS+re89KqUNN3zdYwERqtUq7PawhuaO77WLqFLM+upGWLHCuAJ
        L7xILfwKIoulqsMF7rsRdeq0vg==
X-Google-Smtp-Source: APXvYqwaJy44xLUcomlnQMaDUP+YXFX79GVWjI+mmDWLVhb2A0+lU0o3maK/r4+B08ecBIRY3EXgPw==
X-Received: by 2002:aa7:9609:: with SMTP id q9mr32391565pfg.232.1566359962596;
        Tue, 20 Aug 2019 20:59:22 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e50::2])
        by smtp.gmail.com with ESMTPSA id i9sm32590345pgo.46.2019.08.20.20.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 20:59:22 -0700 (PDT)
Date:   Tue, 20 Aug 2019 20:59:19 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 08/38] nfp: Convert to XArray
Message-ID: <20190820205919.4a75da2e@cakuba.netronome.com>
In-Reply-To: <20190820223259.22348-9-willy@infradead.org>
References: <20190820223259.22348-1-willy@infradead.org>
 <20190820223259.22348-9-willy@infradead.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 15:32:29 -0700, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>=20
> A minor change in semantics where we simply store into the XArray rather
> than insert; this only matters if there could already be something stored
> at that index, and from my reading of the code that can't happen.
>=20
> Use xa_for_each() rather than xas_for_each() as none of these loops
> appear to be performance-critical.
>=20
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks reasonable (indeed IIRC there should not be anything at the
index we try to store to). I'll try to test tomorrow (CCing maintainers
could speed things up a little.. =F0=9F=A4=AD)

> @@ -285,9 +275,9 @@ static void
>  nfp_abm_qdisc_clear_mq(struct net_device *netdev, struct nfp_abm_link *a=
link,
>  		       struct nfp_qdisc *qdisc)
>  {
> -	struct radix_tree_iter iter;
>  	unsigned int mq_refs =3D 0;
> -	void __rcu **slot;
> +	unsigned long index;
> +	struct nfp_qdisc *mq;

Could you keep the variables sorted longest to shortest as is customary
in networking code if you respin?
