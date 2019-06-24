Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A685196B
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732377AbfFXRUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:20:50 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41798 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731245AbfFXRUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:20:49 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so7891035pff.8
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 10:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E/WSdwMcIOuHsAIUuoECa7abjZZ1EFIXnox38pXVgXU=;
        b=bdDQEejv+QxmNeSM+mui7588Sya038Fblfqo5geh4Nzumxx/kPswR0p8TtalAHuHmf
         oRvyg2vyKylXE3Cp9h7C0YMQ2DQUUPPgnVc9shyFPqO20psEMmzm++eIbZQRnqdTrL/r
         txclDgxCq5wEvY4AtiJerz4hYMuPbg/2h5Jei7w2eD2knq2fsTe4+IBvj/laL4KaVIfT
         hUx3Yk9R397WzBIUEkYsbzQP7qhZBv3c0NnBMSd9fL5Osz1KxWB/DhwnGZx6oyntqb39
         ysQeap31g3UojEQq6UXdTY/2H3Vjxt9PAE5tIGB6Zi5bb6lRi2Gi/UA7TBe+eIcuzCKL
         xzTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E/WSdwMcIOuHsAIUuoECa7abjZZ1EFIXnox38pXVgXU=;
        b=qONrLDUKGAiO9PBHrG55g4KR9NkskWWs4/+NOKpZXAmka45JW7Yk0bDkibHbwH1cCE
         pFV+G/R+j2ZqjzxkPrOxeiAr3AfXk7INKL42kLW6fIqTDXGNkx9MdNxzydUvieOfwgM8
         8s/+ZCZEldTkbDKyBguewcf91dnEvpNCHNzuwtctjxXCUle1++YKKA2OnshwMcFD5J9e
         ryfH9beuAnU2c2zM+r5IQ+th08qcghcnOpPLjvGWOqEvedgSj09rMaUDIPYpgt0BKBqg
         ngu9JFh/4Lw8stU07++KAQvqZccfbCoijGvx12q1scxVdeba91miFrIkXkGPdPvi11K5
         mNxA==
X-Gm-Message-State: APjAAAV1YgnvTa3PEZ2N3l5qLShMyoB0ZnGiLiTYlgr40tLwBSetY7rB
        cYQO1nh9jCCdPhtq+x74PmWGXA==
X-Google-Smtp-Source: APXvYqwQ34qmOBh8xdt9eWyRTLHkQCX+Uz9ejP3M5LqFVR7o/avBTeGu4hwKEs9Jyy8oLV1IlSLkJg==
X-Received: by 2002:a65:4342:: with SMTP id k2mr34178064pgq.218.1561396848528;
        Mon, 24 Jun 2019 10:20:48 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s9sm84234pjp.7.2019.06.24.10.20.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 10:20:48 -0700 (PDT)
Date:   Mon, 24 Jun 2019 10:20:41 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org
Subject: Re: [PATCH iproute2 0/3] do not set IPv6-only options on IPv4
 addresses
Message-ID: <20190624102041.25224fae@hermes.lan>
In-Reply-To: <cover.1561394228.git.aclaudi@redhat.com>
References: <cover.1561394228.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jun 2019 19:05:52 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> 'home', 'nodad' and 'mngtmpaddr' options are IPv6-only, but
> it is possible to set them on IPv4 addresses, too. This should
> not be possible.
> 
> Fix this adding a check on the protocol family before setting
> the flags, and exiting with invarg() on error.
> 
> Andrea Claudi (3):
>   ip address: do not set nodad option for IPv4 addresses
>   ip address: do not set home option for IPv4 addresses
>   ip address: do not set mngtmpaddr option for IPv4 addresses
> 
>  ip/ipaddress.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 

Maybe this should be a warning, not a failure.
A little concerned that there will be some user with a scripted setup
that this breaks.
