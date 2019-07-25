Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706C0759C6
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 23:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfGYVjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 17:39:21 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38942 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbfGYVjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 17:39:20 -0400
Received: by mail-io1-f65.google.com with SMTP id f4so100469443ioh.6
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 14:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=MVMrVWNFnNss18BVoynCaNT9FFfQRG4oyPvyVoYVeVQ=;
        b=JlJJLeiK9UIRNZ9dvKY5rrefVwKiNxwhSaHa81nbOPfvzkn1Cng74RQnF1kRS4Gr+b
         vTVys4Zzk4O9lPTztAA7iqjsgB0Z42F7uEcg0Zjyrf7IkKdo9EKzbJSJ/RbD7y8Pahr1
         2p7oUAaYDes4ResdTfDm6MCulsYl8BOcf5e9cvtDaH9jPfljDBRiyRcI+pL6BS3X1CII
         O/34LvCvMUmC1sPG14hA+jaUDW4kkHrpOFIPBiWEFjJkKK3mKl0f3x8C7aj3V3t1/rHP
         RWRK+r/G5hNW80k2pEVFfkCLpr3Ckn5SRlcWvqRzlE2RVe2RwLGy5anLhii/+j1eoRvf
         TxPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=MVMrVWNFnNss18BVoynCaNT9FFfQRG4oyPvyVoYVeVQ=;
        b=UPT4Fj+wV4rt5QFtvKJxRGkaYU4JnlsAZOellFfty1iyiP0wx6UU/Lk1Y6ZEar9u6m
         Csg1OrfEx1jqlj3FYATAu6kNZQgKDb5dqscCDDyEu/rHXCRKg+2677IlntvN20r3xTg6
         P+T8mIroqjk02iDXNgi7evN1lrdqMFKKYeM6pjGN6VJgy99AH7xbrVLKy4444gvp8kW6
         oPacyrcg+a750QzDyWPG4NzEZDAufnjjesDhRbOdMSRHGBP3JaxlmsQilgAUfLNb0tLS
         diVyRqvxCiWl04re6rKEx7b6yMU8NoduRunRhmKAyewx+zuo6U6Px/re2w0LIpBA27zg
         3UcA==
X-Gm-Message-State: APjAAAVEon2hChbm5UbJHq045qKOU6PzcPcnAqgpZzg9P3Wa+N37U2eo
        SBVTp5USzPMqcuRSbYBQfd4=
X-Google-Smtp-Source: APXvYqwoGgCXEblMRV1ksBjK5IBJbQIP6IAEZ63JkvsIKbADw5qrRMjyOrctv4QSgD7K5WDbbJvcow==
X-Received: by 2002:a02:90c8:: with SMTP id c8mr16117093jag.22.1564090760032;
        Thu, 25 Jul 2019 14:39:20 -0700 (PDT)
Received: from sevai ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id c81sm78163157iof.28.2019.07.25.14.39.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 14:39:19 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/2] net sched: update skbedit action for batched events operations
References: <1562970120-29517-1-git-send-email-mrv@mojatatu.com>
        <20190713.192344.1454771658469437265.davem@davemloft.net>
Date:   Thu, 25 Jul 2019 17:39:18 -0400
In-Reply-To: <20190713.192344.1454771658469437265.davem@davemloft.net> (David
        Miller's message of "Sat, 13 Jul 2019 19:23:44 -0700 (PDT)")
Message-ID: <85sgqt3ibd.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Roman Mashak <mrv@mojatatu.com>
> Date: Fri, 12 Jul 2019 18:21:59 -0400
>
>> Add get_fill_size() routine used to calculate the action size
>> when building a batch of events.
>> 
>> Signed-off-by: Roman Mashak <mrv@mojatatu.com>
>
> Please add an appropriate Fixes: tag, and also when you respin this provide the
> required "[PATCH 0/N] " header posting explaining what the series is doing at
> a high level, how it is doing it, and why it is doing it that way.

Thanks for feedback, I've sent v2 of this patchset.
