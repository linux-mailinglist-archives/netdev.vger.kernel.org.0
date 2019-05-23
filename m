Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D67428DCD
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 01:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388177AbfEWXcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 19:32:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43620 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387693AbfEWXcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 19:32:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id t7so7711489wrr.10
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 16:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MQNsmP1P/rHu4pf7TkRHaUkS0wq3JfpJegeEE8fCBPA=;
        b=KrKsfdZNgNpcOMjc/cqcYW7W0cuK7Cg3vEz6XZcuoeCv2jO68eqnTIVTI2l5sKl03d
         2hSbo/rmNjXAS+oAi9sNyKe2LqBRG4sbAIw4JDNdoQd73Z6CCdEx97Pundd32BSErj/P
         vtZG5QnYtLiiOpXCBZkPajhS62KCZR24wI00CKjxRHaok6QshqVIsyrs0W4GRNG937g5
         RfOOmNQ9swnf04IEq36Wk4PgGRLyHj70kdssrCAwhBY/39ru8OLIaq5kvhh9/iufx3Y/
         bPwVLFB6v+ABgzO+6+7mSeVg5bGTJ33QImg6ukWMBMQ/ewn9mzg5ybwqSC5tS7kATBKl
         ffjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MQNsmP1P/rHu4pf7TkRHaUkS0wq3JfpJegeEE8fCBPA=;
        b=VhWg7/wm9DLV1Kqk/ZDqOfX9BjaEX10ZLcyvEqEsMHVDVhcjUJqisgt9uy5OntkhoK
         gSsfvEbnu4KaTFenD2YS9bjIk07wgOMRaRME8D4f06J1IxGNsxYI7okZGsXdGGC7LjfB
         hONv61Xfu08IEFQ+qVkDOgyvuTKlCLahXstrTmYHGCtFhgO8vvX33kPRxqWEJh8/bau9
         EP6YFDIjIPA63yIQo8w3TiSdzEPdqC/zPL2jz+3t1UW0qQSt//SZN1CTJWh9Bhn9/9NJ
         aP3dSPfL73IgJ+Ey0dr1LCMiyi5gT7BuqJ5JanYk4Ke5uRdiOzSnG9OVWgNEDFpr7dMb
         GcNg==
X-Gm-Message-State: APjAAAX7026ZutR8u6F6liIb8DQsxuy4NOEv/8VnQ0vhd7Fl1MNclXIB
        XS8W4y7bh2aWXzq0LZYoUaPA9t3aVcvw76SmBiUVzw==
X-Google-Smtp-Source: APXvYqyaN+7YNRMMyUED3zvM6jM7khb02piPdViXS25b3zuOqvRRBt8Owq5ziHIaveuFC14xjLqY0yLAo439JntUVrU=
X-Received: by 2002:adf:f250:: with SMTP id b16mr29309410wrp.24.1558654318077;
 Thu, 23 May 2019 16:31:58 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1558557001.git.jbaron@akamai.com> <20190523.121435.1508515031987363334.davem@davemloft.net>
In-Reply-To: <20190523.121435.1508515031987363334.davem@davemloft.net>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Thu, 23 May 2019 16:31:21 -0700
Message-ID: <CAK6E8=fXs5kHVhcNyVHY5V3ZDkn3_FBcMPSnFoe4Fir-qU_1BA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/6] add TFO backup key
To:     David Miller <davem@davemloft.net>
Cc:     jbaron@akamai.com, Eric Dumazet <edumazet@google.com>,
        ilubashe@akamai.com, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 12:14 PM David Miller <davem@davemloft.net> wrote:
>
> From: Jason Baron <jbaron@akamai.com>
> Date: Wed, 22 May 2019 16:39:32 -0400
>
> > Christoph, Igor, and I have worked on an API that facilitates TFO key
> > rotation. This is a follow up to the series that Christoph previously
> > posted, with an API that meets both of our use-cases. Here's a
> > link to the previous work:
> > https://patchwork.ozlabs.org/cover/1013753/
>
> I have no objections.
>
> Yuchung and Eric, please review.
>
> And anyways there will be another spin of this to fix the typo in the documentation
> patch #5.
patch set looks fine. I am testing them w/ our internal TFO packetdrill tests.
>
> Thanks.
