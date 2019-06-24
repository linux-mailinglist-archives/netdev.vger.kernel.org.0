Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48259519B0
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732521AbfFXRh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:37:28 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42253 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729502AbfFXRh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:37:28 -0400
Received: by mail-pl1-f193.google.com with SMTP id ay6so7270573plb.9
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 10:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RwuuIvtxcBljmc7PFWojSi2N+7tyjtOMabnfff7jpmo=;
        b=wNEKXNOWP5PlYCgptKgZXfJolBfYoJLb1MoczYQas9THpCa1SKApTdEiaM93xCZOaI
         6fR/W3O+LArPZ8Z/WwDDGsIFgOmNiwN8s+DW6eHNwCdT8Y5YQDImB3U9OUT/hYJ8w4xx
         +4/t3TQu0kbcQ9kz4GbtAMc+CYKvmKJXZB62kYI2uaZhkS5rgnufTkHAxbap3eKbLjNe
         N66ugUnMkY9ARFqXkAxle6zQpnfLDNtGq88tkYBSrUG/4eRV7ypx1n6l03bkeZlWRgi5
         rOaJy5hrS4jRer/8YsmvumqcpqB/gcnilGjvkNB75QlxxCrK30CewEFybxMRFmLycIrO
         hhBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RwuuIvtxcBljmc7PFWojSi2N+7tyjtOMabnfff7jpmo=;
        b=LSRotEu5mKe2zKReqhyt/EuDd3LY61A2elg9YRiPqQe3j593BOghDjfPCtpYrHqUgk
         iyqKvYonz5aqCOBMtgfSgUxrwWw00E7aFsgS0/Lxqprtf1OJgatCRUcOWpiNim+/bnp7
         4ZVV+2TiTN6vz3hQe4c+O/pA2T8scbtaARDTbNC2tjmeU6IQyapxAjwK8fDXL6YpA8gO
         kuw0mtAOIUbdEHfcaFhTKIXMk5/7RjmTAPb5fESgJeDK1jVFvtHLFeQKOpks0vEBn1b9
         xJGXQ9q4tmpCtTM0sYKVznkVzye7WRtPnOBm2YdoOYAvslnzMndDdOIzlt37eFqWSUid
         wFPQ==
X-Gm-Message-State: APjAAAU+XpyRXTmiUWaJfkebI4cSYDkeoJaBtNQb9UDP8QJaLPmzWQKe
        YJ4cff+xBVkwAGj0cHx5EBSM919YNB+wP0b3/p+ODRrgwvg=
X-Google-Smtp-Source: APXvYqywWCSSedYTgwqIkJyMW8oZCbox9RzzBLyFvc25sU21urptslg5Ui+b5r9UxivbJusrk7t8rPQnHZSGo8fpQg4=
X-Received: by 2002:a17:902:b944:: with SMTP id h4mr24520563pls.179.1561397846032;
 Mon, 24 Jun 2019 10:37:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAKwvOdk9yxnO_2yDwuG8ECw2o8kP=w8pvdbCqDuwO4_03rj5gw@mail.gmail.com>
 <20190624.100609.1416082266723674267.davem@davemloft.net> <CAKwvOdmd2AooQrpPhBVhcRHGNsMoGFiXSyBA4_aBf7=oVeOx1g@mail.gmail.com>
 <20190624.102212.4398258272798722.davem@davemloft.net>
In-Reply-To: <20190624.102212.4398258272798722.davem@davemloft.net>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 24 Jun 2019 10:37:14 -0700
Message-ID: <CAKwvOdkqE_RVosXAe9ULePR8A37CHh6+JtDMaRAghUA41Y_+yg@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] ipv6: constify rt6_nexthop()
To:     David Miller <davem@davemloft.net>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org, kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 10:22 AM David Miller <davem@davemloft.net> wrote:
>
> From: Nick Desaulniers <ndesaulniers@google.com>
> Date: Mon, 24 Jun 2019 10:17:03 -0700
>
> > On Mon, Jun 24, 2019 at 10:06 AM David Miller <davem@davemloft.net> wrote:
> >> And you mean just changing to 'const' fixes something, how?
> >
> > See the warning in the above link (assuming now you have access).
> > Assigning a non-const variable the result of a function call that
> > returns const discards the const qualifier.
>
> Ok thanks for clarifying.
>
> However I was speaking in terms of this fixing a functional bug rather
> than a loss of const warning.

The author stated that this patch was no functional change.  Nicolas,
it can be helpful to include compiler warnings in the commit message
when sending warning fixes, but it's not a big deal.  Thanks for
sending the patches.
-- 
Thanks,
~Nick Desaulniers
