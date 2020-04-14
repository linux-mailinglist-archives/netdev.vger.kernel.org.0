Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DEB1A8B08
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 21:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504967AbgDNTi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 15:38:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30982 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2504937AbgDNTiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 15:38:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586893088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K7rEujuH9mCHHkQNQF3bIC7vs8ss/qE9yTiJvgoWENY=;
        b=RUtwHLrSbkaJMm0IrMRS9rm0IZmdDO3dP2/xxkZGnWHf/t7JN2MxaoW4q5N/mb6RPBFLLy
        P947ZeFYc1NGC7YZYlO7Mw3aqTJi1Hqp7+A3wGm8Zn3fqfDRZznd1zIsAv1KIqCY5KfpPZ
        cSeVgzUqVzTuzDNClrQrNJ8UGRg4zNQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-BEtuMjG3PL-f8LyKeyu6gQ-1; Tue, 14 Apr 2020 15:38:03 -0400
X-MC-Unique: BEtuMjG3PL-f8LyKeyu6gQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A5A58017F3;
        Tue, 14 Apr 2020 19:37:58 +0000 (UTC)
Received: from llong.remote.csb (ovpn-118-173.rdu2.redhat.com [10.10.118.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0277F100E7E3;
        Tue, 14 Apr 2020 19:37:51 +0000 (UTC)
Subject: Re: [PATCH v2 2/2] crypto: Remove unnecessary memzero_explicit()
To:     =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Matthew Wilcox <willy@infradead.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-ppp@vger.kernel.org,
        wireguard@lists.zx2c4.com, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fscrypt@vger.kernel.org, ecryptfs@vger.kernel.org,
        kasan-dev@googlegroups.com, linux-bluetooth@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-nfs@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        cocci@systeme.lip6.fr, linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org
References: <20200413211550.8307-1-longman@redhat.com>
 <20200413222846.24240-1-longman@redhat.com>
 <eca85e0b-0af3-c43a-31e4-bd5c3f519798@c-s.fr>
 <e194a51f-a5e5-a557-c008-b08cac558572@redhat.com>
 <20200414191601.GZ25468@kitsune.suse.cz>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <578fe9b6-1ccd-2698-60aa-96c3f2dd2c31@redhat.com>
Date:   Tue, 14 Apr 2020 15:37:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200414191601.GZ25468@kitsune.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/20 3:16 PM, Michal Such=E1nek wrote:
> On Tue, Apr 14, 2020 at 12:24:36PM -0400, Waiman Long wrote:
>> On 4/14/20 2:08 AM, Christophe Leroy wrote:
>>>
>>> Le 14/04/2020 =E0 00:28, Waiman Long a =E9crit=A0:
>>>> Since kfree_sensitive() will do an implicit memzero_explicit(), ther=
e
>>>> is no need to call memzero_explicit() before it. Eliminate those
>>>> memzero_explicit() and simplify the call sites. For better correctne=
ss,
>>>> the setting of keylen is also moved down after the key pointer check=
.
>>>>
>>>> Signed-off-by: Waiman Long <longman@redhat.com>
>>>> ---
>>>> =A0 .../allwinner/sun8i-ce/sun8i-ce-cipher.c=A0=A0=A0=A0=A0 | 19 +++=
++-------------
>>>> =A0 .../allwinner/sun8i-ss/sun8i-ss-cipher.c=A0=A0=A0=A0=A0 | 20 +++=
++--------------
>>>> =A0 drivers/crypto/amlogic/amlogic-gxl-cipher.c=A0=A0 | 12 +++------=
--
>>>> =A0 drivers/crypto/inside-secure/safexcel_hash.c=A0 |=A0 3 +--
>>>> =A0 4 files changed, 14 insertions(+), 40 deletions(-)
>>>>
>>>> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
>>>> b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
>>>> index aa4e8fdc2b32..8358fac98719 100644
>>>> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
>>>> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
>>>> @@ -366,10 +366,7 @@ void sun8i_ce_cipher_exit(struct crypto_tfm *tf=
m)
>>>> =A0 {
>>>> =A0=A0=A0=A0=A0 struct sun8i_cipher_tfm_ctx *op =3D crypto_tfm_ctx(t=
fm);
>>>> =A0 -=A0=A0=A0 if (op->key) {
>>>> -=A0=A0=A0=A0=A0=A0=A0 memzero_explicit(op->key, op->keylen);
>>>> -=A0=A0=A0=A0=A0=A0=A0 kfree(op->key);
>>>> -=A0=A0=A0 }
>>>> +=A0=A0=A0 kfree_sensitive(op->key);
>>>> =A0=A0=A0=A0=A0 crypto_free_sync_skcipher(op->fallback_tfm);
>>>> =A0=A0=A0=A0=A0 pm_runtime_put_sync_suspend(op->ce->dev);
>>>> =A0 }
>>>> @@ -391,14 +388,11 @@ int sun8i_ce_aes_setkey(struct crypto_skcipher
>>>> *tfm, const u8 *key,
>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_dbg(ce->dev, "ERROR: Invalid keylen =
%u\n", keylen);
>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>>>> =A0=A0=A0=A0=A0 }
>>>> -=A0=A0=A0 if (op->key) {
>>>> -=A0=A0=A0=A0=A0=A0=A0 memzero_explicit(op->key, op->keylen);
>>>> -=A0=A0=A0=A0=A0=A0=A0 kfree(op->key);
>>>> -=A0=A0=A0 }
>>>> -=A0=A0=A0 op->keylen =3D keylen;
>>>> +=A0=A0=A0 kfree_sensitive(op->key);
>>>> =A0=A0=A0=A0=A0 op->key =3D kmemdup(key, keylen, GFP_KERNEL | GFP_DM=
A);
>>>> =A0=A0=A0=A0=A0 if (!op->key)
>>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 return -ENOMEM;
>>>> +=A0=A0=A0 op->keylen =3D keylen;
>>> Does it matter at all to ensure op->keylen is not set when of->key is
>>> NULL ? I'm not sure.
>>>
>>> But if it does, then op->keylen should be set to 0 when freeing op->k=
ey.=20
>> My thinking is that if memory allocation fails, we just don't touch
>> anything and return an error code. I will not explicitly set keylen to=
 0
>> in this case unless it is specified in the API documentation.
> You already freed the key by now so not touching anything is not
> possible. The key is set to NULL on allocation failure so setting keyle=
n
> to 0 should be redundant. However, setting keylen to 0 is consisent wit=
h
> not having a key, and it avoids the possibility of leaking the length
> later should that ever cause any problem.

OK, I can change it to clear the key length when the allocation failed
which isn't likely.

Cheers,
Longman


