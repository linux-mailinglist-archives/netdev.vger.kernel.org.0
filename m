Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71E4213CE0E
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 21:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgAOUYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 15:24:04 -0500
Received: from mail-qt1-f175.google.com ([209.85.160.175]:38450 "EHLO
        mail-qt1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgAOUYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 15:24:04 -0500
Received: by mail-qt1-f175.google.com with SMTP id c24so6163920qtp.5
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 12:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=09JRt/ii1ODlbKw0i3blhNk6J9YSeIEdOPRW3kj9DNM=;
        b=RWO/QbpvIV/VV9DSMPznUy1Htq0iY/LzfEO5E2bzvU3sOZy1JlRzyFUoNN2JEbM7Bp
         sEcsszSsxihzHt45z3WCB1TGcuOTfUvtSneAOkeATtK3uMGK5+inNDQdng/rNNCzS9nO
         tDf2poY5O4S/X0HN52FOMExZOSo/Pu2YULFW4M6rCw46NgQpmjfVvCUJFoK2kwajUMdY
         ac2vOu7oetXQ4a4rrJtQpbCqlZXBBOlwdUtA4ej7lQzNUHQPgS7XAKxW/phWQ41Szga3
         IuFXpljZzjZPLPBNgJtz7ox6w0KUC88l8QOQw6IrjR+hnEfxMHbjZ+4iy927y33blUHG
         MGIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=09JRt/ii1ODlbKw0i3blhNk6J9YSeIEdOPRW3kj9DNM=;
        b=IRmwoVcp7w7MBaIW42Hmc0oXdCNLpqOF3cbhr4C9M3Nq0knmT8hfudAjHpBiYAvmyL
         0FafyoEaq7C1gJXq+9XrwBZnFpYblN1IazxSfmWDOfBp5Lmo7UC/WGoZb42FEO5mKQ98
         aMAWonF/7AFIcRL5uZb3/SS8B7+XQaylveW05uYUS0xkN6llyUhL0PKLqmVxAzyaC0KC
         BUWZQMmZXjw+Gjygfflp44Fw7igmTdOMru++tqaaxzz27puOOciw2S26cYmoIrWAvAip
         KqDRzMMc2Wy2NwRoMLmjy3n1UNN6gpQH3JArH1unxAJV11S2uKinlHX7ng85QDS20L5L
         SI5Q==
X-Gm-Message-State: APjAAAWGrgYiRcpFs83M2YWgV/n7DWql2QnZPaE21zREj7TYxB6OERGP
        mLuanoED6McKWBEhWVbibILDXRrT
X-Google-Smtp-Source: APXvYqxSAYiU+W48Z2lSaQpS2Mmbaqz0DLy8ucQz0v9qWSCSHyq4DLotSqPTyCbEtUOD+8XFYl6MFA==
X-Received: by 2002:ac8:342c:: with SMTP id u41mr440399qtb.86.1579119842970;
        Wed, 15 Jan 2020 12:24:02 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:b4a4:d30b:b000:b744? ([2601:282:800:7a:b4a4:d30b:b000:b744])
        by smtp.googlemail.com with ESMTPSA id k62sm8893288qkc.95.2020.01.15.12.24.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 12:24:02 -0800 (PST)
Subject: Re: vrf and multicast is broken in some cases
To:     Ben Greear <greearb@candelatech.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e439bcae-7d20-801c-007d-a41e8e9cd5f5@candelatech.com>
 <3906c6fe-e7a7-94c1-9d7d-74050084b56e@gmail.com>
 <dbefe9b1-c846-6cc6-3819-520fd084a447@candelatech.com>
 <20200115191920.GA1490933@splinter>
 <2b5cae7b-598a-8874-f9e9-5721099b9b6d@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <561728b3-7527-f455-77c8-02bee2284a18@gmail.com>
Date:   Wed, 15 Jan 2020 13:24:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <2b5cae7b-598a-8874-f9e9-5721099b9b6d@candelatech.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/20 1:00 PM, Ben Greear wrote:
> I'll work on adding an un-reachable route when a real gateway is not
> configured...

I recommend a high metric unreachable default route every time you
create a VRF for just the reason Ido mentioned. You can always add a
lower priority default as needed.

I think we need an update to the VRF documetnation.
