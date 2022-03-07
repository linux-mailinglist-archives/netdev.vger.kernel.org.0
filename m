Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F424D08A5
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 21:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbiCGUmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 15:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbiCGUmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 15:42:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23F217C7BF
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 12:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646685667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=65DoVEa1W2s4mlgCk5N1pF5mtpcjUybZoVdasl9gBZA=;
        b=eRYoHPmX++QGw5jEw0xFbTM7OqcMjSqBDEJnuaIBXXk9SWUPozvnDdVoVN4Cw3Vjb4J6z8
        uGm2X6pX7hyS74Bkkcx0wczqPOdcPSoFCxBI7cXk8IpcYwPScFVJihpNCBQTmOdmS/Wngo
        t7/Ts9CCak+606Qmb7MYjdyAdl/TMFc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-FAK7Vr8VMHiIERNQCBRwow-1; Mon, 07 Mar 2022 15:41:05 -0500
X-MC-Unique: FAK7Vr8VMHiIERNQCBRwow-1
Received: by mail-ej1-f70.google.com with SMTP id hx13-20020a170906846d00b006db02e1a307so2467570ejc.2
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 12:41:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=65DoVEa1W2s4mlgCk5N1pF5mtpcjUybZoVdasl9gBZA=;
        b=OafaWqd6tsSYIFKkJ/KfGWGZfXMu40YWMiSVDJQlZgNU/BxdSHIzjdmhXJtrRpPHPX
         cKQKimQKg2zGJ/OST5MtV2eJMjik9zARd71BOmOn3q8e/aJBAMpXRp7BpiCDKj7AwcUc
         eNWJ6xijLmyMbrNuLOwXC48ElE5/WCkNdtwn8sZuiRsdnMnsbatKUjNahvtVt9aX/aqj
         MAeyFbZ2xSKGAA2lBelnHPQigKpHhIaZ9t57pw+65qbLYBJEbXxDmSOeMbYwMA7sEbiv
         ioMxSwQfU/BeZXyDuqWhlllvTHA5uqTrxdvFqYsa3VjbnoLfSZSSXMpEoW9TcqLsRFxh
         Nk1g==
X-Gm-Message-State: AOAM530ss4aiEABb5Dq2CsvlN5ipwm5RWsBDuPjn8R2kmMNkTy6AEKaw
        enUTUueLeOfpzmnJMZu0KQcQ1/fxR37mVQnYVpK26jfI+j7GNvcuErLUl30WrSj1AvuIVBUCYEt
        2xRVGLnVTzVjOjqmu
X-Received: by 2002:a05:6402:369b:b0:416:5aa6:1584 with SMTP id ej27-20020a056402369b00b004165aa61584mr3891023edb.28.1646685663612;
        Mon, 07 Mar 2022 12:41:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6F8MiIRe03TOCJmXfREpBtaXRtN9Fc6/IFwvRcBQFF1wB1dRNGnFvV4ZmAdwxfIVKbbQJeA==
X-Received: by 2002:a05:6402:369b:b0:416:5aa6:1584 with SMTP id ej27-20020a056402369b00b004165aa61584mr3890994edb.28.1646685663106;
        Mon, 07 Mar 2022 12:41:03 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id u9-20020a170906124900b006ce88a505a1sm5240692eja.179.2022.03.07.12.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 12:41:02 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E9060132007; Mon,  7 Mar 2022 21:41:01 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] sch_fq_codel: fix running with classifiers that
 don't set a classid
In-Reply-To: <20220307182602.16978-2-nbd@nbd.name>
References: <20220307182602.16978-1-nbd@nbd.name>
 <20220307182602.16978-2-nbd@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 07 Mar 2022 21:41:01 +0100
Message-ID: <87lexl7axu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> If no valid classid is provided, fall back to calculating the hash directly,
> in order to avoid dropping packets
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

While I agree that this behaviour makes more sense, it's also a
user-facing API change; I suppose there may be filters out there relying
on the fact that invalid (or unset) class ID values lead to dropped
packets?

-Toke

