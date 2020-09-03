Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038F425B9F8
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 07:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgICFBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 01:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgICFBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 01:01:31 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BD4C061244;
        Wed,  2 Sep 2020 22:01:31 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id z25so1341121iol.10;
        Wed, 02 Sep 2020 22:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VhropMQESNSMSxgIqr1ZDerfNQ9kD0plBvpn1qDMszM=;
        b=nMzVYFt6wL+sFTiIRt+EX4YPgpv0eQNE7JufaNot1Lr+3QgrM7JZ/voUg/qQ7UbL+p
         DQFGu5umpYZ+THfWnkJ4mXU4H4h7jITCMmeZ+hS79U8+8OwI8Z5TRXx+hMbyzC4DHb/K
         5aNKWNw8+2M6tDNSwADL1VeJDZOaPykT8EDJepafKstZiG2xtkhfmmcVB69wrouZM7ZY
         5am1zK3eAt82Pih+91tSc63Z+VPnOGgGbmATRryeJT17ziZG0VYHgrEabiSxD9JssVNQ
         AFY4pFaMCvYNN1+VSpco4qt67qf/LmkFhAMXS5CLyISWgtFm7KnJu/gzO59tJ1a0ci0F
         HsFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VhropMQESNSMSxgIqr1ZDerfNQ9kD0plBvpn1qDMszM=;
        b=EbZ1jR0O475+3q6f1kCMg0ffByXo5jPjBPD45u8/INxBzOaSJfeu9YyBl+d8XDyxcW
         mt6ZLQfo73mIJ+7CBZzk1bR/3UA0m+6GwIfdnYGFD1RuBFsnW50f+EmXf5hlhSFDtk++
         TgKfBeuVTsU6qu+jqMKLTH0aGa/tF51jKciWGgXttqUBUaffc8ISObOUr5z6SQUxDjRu
         xLGGnjmq5pHtV5uwh1y4bmu1I+Uz4g1cYhL6ZeLhf0R9uQ9sGCzkHWFUbfso+E4TU+NY
         zrqlmcQ6XoK02zhS4UfxLTuvGQfihXy2e02YGWmrFI4ihkSFFKf+OpEoYHMlN8SjJaH+
         D+cQ==
X-Gm-Message-State: AOAM532QkEvUJOvBTa1LDoiewRCOJXWxRtOHeHYnKJfPZ5rEyTg8xgUY
        +6z/Sr56In1s5NmF3SD9Rbey1v9/oqh2vCL1RPs=
X-Google-Smtp-Source: ABdhPJxSLl08LwgQXvNl2k2JfN0eiQKtQpbmY5tdMgIWtI3pbR9WbDSPo++rGQCGHTg4BzBcS/f4SrxAilGknxK49gA=
X-Received: by 2002:a05:6602:1589:: with SMTP id e9mr1576006iow.85.1599109289807;
 Wed, 02 Sep 2020 22:01:29 -0700 (PDT)
MIME-Version: 1.0
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com> <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
 <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com> <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
 <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com> <CANE52Ki8rZGDPLZkxY--RPeEG+0=wFeyCD6KKkeG1WREUwramw@mail.gmail.com>
 <20200822032800.16296-1-hdanton@sina.com> <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
 <20200825032312.11776-1-hdanton@sina.com> <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
 <20200825162329.11292-1-hdanton@sina.com> <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
 <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com>
 <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
 <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AB7fd2vUOQ@mail.gmail.com>
 <20200827125747.5816-1-hdanton@sina.com> <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
In-Reply-To: <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 2 Sep 2020 22:01:17 -0700
Message-ID: <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Kehuan Feng <kehuan.feng@gmail.com>
Cc:     Hillf Danton <hdanton@sina.com>, Jike Song <albcamus@gmail.com>,
        Josh Hunt <johunt@akamai.com>, Paolo Abeni <pabeni@redhat.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000002d36f305ae61a588"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000002d36f305ae61a588
Content-Type: text/plain; charset="UTF-8"

Hello, Kehuan

Can you test the attached one-line fix? I think we are overthinking,
probably all
we need here is a busy wait.

Thanks.

--0000000000002d36f305ae61a588
Content-Type: text/x-patch; charset="US-ASCII"; name="qdisc-seqlock.diff"
Content-Disposition: attachment; filename="qdisc-seqlock.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_kemc7lqb0>
X-Attachment-Id: f_kemc7lqb0

ZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L3NjaF9nZW5lcmljLmggYi9pbmNsdWRlL25ldC9zY2hf
Z2VuZXJpYy5oCmluZGV4IGQ2MGU3YzM5ZDYwYy4uZmMxYmFjZGIxMDJiIDEwMDY0NAotLS0gYS9p
bmNsdWRlL25ldC9zY2hfZ2VuZXJpYy5oCisrKyBiL2luY2x1ZGUvbmV0L3NjaF9nZW5lcmljLmgK
QEAgLTE1Niw4ICsxNTYsNyBAQCBzdGF0aWMgaW5saW5lIGJvb2wgcWRpc2NfaXNfZW1wdHkoY29u
c3Qgc3RydWN0IFFkaXNjICpxZGlzYykKIHN0YXRpYyBpbmxpbmUgYm9vbCBxZGlzY19ydW5fYmVn
aW4oc3RydWN0IFFkaXNjICpxZGlzYykKIHsKIAlpZiAocWRpc2MtPmZsYWdzICYgVENRX0ZfTk9M
T0NLKSB7Ci0JCWlmICghc3Bpbl90cnlsb2NrKCZxZGlzYy0+c2VxbG9jaykpCi0JCQlyZXR1cm4g
ZmFsc2U7CisJCXNwaW5fbG9jaygmcWRpc2MtPnNlcWxvY2spOwogCQlXUklURV9PTkNFKHFkaXNj
LT5lbXB0eSwgZmFsc2UpOwogCX0gZWxzZSBpZiAocWRpc2NfaXNfcnVubmluZyhxZGlzYykpIHsK
IAkJcmV0dXJuIGZhbHNlOwo=
--0000000000002d36f305ae61a588--
