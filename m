Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0DC18E5A4
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 01:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgCVAqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 20:46:44 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:21082 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728178AbgCVAqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 20:46:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584838003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qXvBGWf4H3tlxTPY3JL9NJZyGrJzCSjYj7K4kPcMwd8=;
        b=MI8sjx3xD22xWitANNr5GPdz6PROB/MNQlPUiUdmZrUXr3hDhO/lui/XtFxcxQ/cR5MKKm
        +qK3K4bXsvYrq4Qx25rhd2mlNne5NTMWgj9S1OZfR4rXfyE4gujkTDESbhAaNW4IvAcna1
        uDA1SOU3m0NoV+ij+bkYKoqo77rZbPw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-I8Rx9gchNNiov0sHixcL3w-1; Sat, 21 Mar 2020 20:46:39 -0400
X-MC-Unique: I8Rx9gchNNiov0sHixcL3w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32D37100550E;
        Sun, 22 Mar 2020 00:46:36 +0000 (UTC)
Received: from llong.remote.csb (ovpn-112-193.rdu2.redhat.com [10.10.112.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79FD91000325;
        Sun, 22 Mar 2020 00:46:33 +0000 (UTC)
Subject: Re: [PATCH v7 2/2] KEYS: Avoid false positive ENOMEM error on key
 read
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Eric Biggers <ebiggers@google.com>,
        Chris von Recklinghausen <crecklin@redhat.com>
References: <20200321184932.16579-1-longman@redhat.com>
 <20200321184932.16579-3-longman@redhat.com>
 <e3d7a227-8915-5c00-cd34-fe2db7fc7121@I-love.SAKURA.ne.jp>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <03c0c59e-a84b-bd75-6b3f-7f6467d806e2@redhat.com>
Date:   Sat, 21 Mar 2020 20:46:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <e3d7a227-8915-5c00-cd34-fe2db7fc7121@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/20 8:31 PM, Tetsuo Handa wrote:
> On 2020/03/22 3:49, Waiman Long wrote:
>> +	do {
>> +		if (ret > key_data_len) {
>> +			if (unlikely(key_data))
>> +				__kvzfree(key_data, key_data_len);
>> +			key_data_len = ret;
>> +			continue;	/* Allocate buffer */
> Excuse me, but "continue;" inside "do { ... } while (0);" means "break;"
> because "while (0)" is evaluated before continuing the loop.

You are right. My mistake. Will send out a new one for patch 2.

-Longman


