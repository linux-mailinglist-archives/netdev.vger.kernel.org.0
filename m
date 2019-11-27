Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6A2C10B03F
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 14:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfK0NfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 08:35:19 -0500
Received: from a27-188.smtp-out.us-west-2.amazonses.com ([54.240.27.188]:43342
        "EHLO a27-188.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726320AbfK0NfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 08:35:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574861718;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=xRJSCe1Xvlng2VkhCzdpjWjeFzL2KV96xV3U+FPklvM=;
        b=C+7RJ/oR3c0TzaAOLRHiK3OMBOP/VHKv+aNTKye4dDiXR5arBn2AotKgfs4JMJdW
        s/FzmF/WnUeXnR79i1BVEAcN70VrH1wb5BnB2bJMven5VuYTaEa3Z8BeJ32eU+nIVDw
        qK+eHZP5Q7fj5pnPXyPFZMRzEe7r+D+2/bqvlJLI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574861718;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=xRJSCe1Xvlng2VkhCzdpjWjeFzL2KV96xV3U+FPklvM=;
        b=PmgANr3FKP+yUSZM/ZzfiYazsCot7DEq1Xy4zSGA9E7O1+8jlhT6FTT/u2rdhgrM
        UfJrvkqY3uDP+VY19FumnKayaPGh4h9y7f8W6Opj7p/5RJTrD8X4ESfshxVdriDlNUD
        tGh17KJ4jd8hqd0GLTzrfqcaferuulqIfna8IAQA=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 092E8C4479C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Austin Kim <austindh.kim@gmail.com>
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmsmac: Remove always false 'channel < 0' statement
References: <20191127054358.GA59549@LGEARND20B15>
        <46dfe877-4f32-b763-429f-7af3a83828f0@cogentembedded.com>
        <CADLLry4jOr1S7YhdN5saRCXSnjTt_J=TB+sm=CjbcW9NJ4V7Pg@mail.gmail.com>
Date:   Wed, 27 Nov 2019 13:35:18 +0000
In-Reply-To: <CADLLry4jOr1S7YhdN5saRCXSnjTt_J=TB+sm=CjbcW9NJ4V7Pg@mail.gmail.com>
        (Austin Kim's message of "Wed, 27 Nov 2019 22:02:49 +0900")
Message-ID: <0101016ead12c1ea-1f40653d-0ca6-4e03-8b7b-7fceb2ec87bf-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SES-Outgoing: 2019.11.27-54.240.27.188
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Austin Kim <austindh.kim@gmail.com> writes:

> 2019=EB=85=84 11=EC=9B=94 27=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 7:48=
, Sergei Shtylyov
> <sergei.shtylyov@cogentembedded.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>
>> On 27.11.2019 8:43, Austin Kim wrote:
>>
>> > As 'channel' is declared as u16, the following statement is always fal=
se.
>> >     channel < 0
>> >
>> > So we can remove unnecessary 'always false' statement.
>>
>>     It's an expression, not a statement.
>>
>
> According to below link, it is okay to use 'statement' in above case.
> https://en.wikipedia.org/wiki/Statement_(computer_science)

I don't have time to start arguing about this, and I'm no C language
lawyer either, but all I say is that I agree with Sergei here.

> Why don't you show your opition about patch rather than commit message?

But this comment is not ok. Patch review (including commit logs) is the
core principle of upstream development so you need to have an open mind
for all comments, even the ones you don't like.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
