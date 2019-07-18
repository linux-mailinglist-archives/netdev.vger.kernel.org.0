Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67FCA6D2A2
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 19:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfGRRTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 13:19:13 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38792 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfGRRTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 13:19:12 -0400
Received: by mail-io1-f65.google.com with SMTP id j6so20370223ioa.5
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 10:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cJj/d44/OfXY/eT4Ll2tJjeWeuBHLmt8sFuQOhig6bs=;
        b=f0wwxpP4her5hS4cqVANL/McSlQ/WtbtbSw8nVS5hMNLViia6PcA191PEutb6REsrw
         mY9PS3DKupPG4vItxU56B6bshYxnOZlGSpsVryNgYCqRjUpZMCBQOdhwfUR/9UDbRBMo
         RBcEcMaswinmCTDKzMhK9Kcj13H0PIfivDFWzzTdHU32MWMLg0UBugLFJLFQUjhUJKsG
         KHF1cq5pxzg8XsaynvgbElsHMPNWSdhqUcYoaDqKJw3z4QgLGr2NmMe8+kD560+f4Q32
         DKRMiWsgMnIemPKDehd3B8cEUN9g9TtEqMDrC7EnL2i+6jPu+pLp6gAVDvV+GxTVA2CO
         toBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cJj/d44/OfXY/eT4Ll2tJjeWeuBHLmt8sFuQOhig6bs=;
        b=DpHHVMY/Buzn3HKQP5nZMneUVP38kufhTgaYwbKsfUnJqv3KZL33NsEazKUUvOJogz
         xjpiThrbvGNi+Z7Zww+LnkqaRbq/c6WK1Ylq+XqnlCTWfl+cvvMnd5kci11/ytNLPGmL
         VByVyYObSQUDWJD4/YLxdqY4dMRWte0nKaqRF3upIFmn6/pJqTBOApyHopeVMiGWp3kS
         +tmLBrGdov37lUtMqxvoIjY4AbhJvZL1w1RxUK/zED1AFgEw3HHKAAgfcA56tHCzQ22M
         jbXp666smAGNCLJnrLtcLmem1ON1oORbI/6tILcak3nvGKFxu/unueL4Rdf+CyWQcn7j
         mUrA==
X-Gm-Message-State: APjAAAUondexiLEQNReasSWAMT5bEe6BcIy2pc8/njhpXm9Hf7nvQUq0
        lUZBwqzAZ7vB4uPVhpcrL8Q=
X-Google-Smtp-Source: APXvYqzM6O+3z6+7Ag0H7VnKcAPpuxq1MTATVPJj6QM6LEhFpKedhvws89v4Tw48kqJa/egjkMu3Yw==
X-Received: by 2002:a02:c6a9:: with SMTP id o9mr51257102jan.90.1563470351889;
        Thu, 18 Jul 2019 10:19:11 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:d57e:4df9:f3b0:1b7c? ([2601:282:800:fd80:d57e:4df9:f3b0:1b7c])
        by smtp.googlemail.com with ESMTPSA id k2sm21713460iom.50.2019.07.18.10.19.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 10:19:11 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] tunnel: factorize printout of GRE key and
 flags
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
References: <547473b8fbab9114f78c1cfe405ccb5f50b0a66b.1562950715.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <52384b8f-e133-1824-5c63-e5fee9785099@gmail.com>
Date:   Thu, 18 Jul 2019 11:19:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <547473b8fbab9114f78c1cfe405ccb5f50b0a66b.1562950715.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/12/19 11:02 AM, Andrea Claudi wrote:
> print_tunnel() functions in ip6tunnel.c and iptunnel.c contains
> the same code to print out GRE key and flags
> 
> This commit factorize the code in a helper function in tunnel.c
> 
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  ip/ip6tunnel.c | 22 ++--------------------
>  ip/iptunnel.c  | 19 ++-----------------
>  ip/tunnel.c    | 26 ++++++++++++++++++++++++++
>  ip/tunnel.h    |  3 +++
>  4 files changed, 33 insertions(+), 37 deletions(-)

applied to iproute2-next. Thanks

