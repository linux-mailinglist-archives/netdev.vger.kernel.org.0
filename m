Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0320B63636C
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237497AbiKWPZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237666AbiKWPZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:25:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4F52BD3
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669217086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+JIKrf57nj1kWRXglPfPJ258p/fyMgl7dlr5TafbPCE=;
        b=Jb4rp/LgO7a7k5hkz0uv4DXBOMoEJzUu3IiG73WPBwvx0LYTSMZpe6Q5bEYxQ7y6cn21vc
        i40t7Y9QFCveT0v4A+opSInCxf+hB9eJx4JFfVfAvwmv0TG8oeDmDhrvUwUAmRVxts/JMx
        GXqCpFEzmgKWunYNasFnPNSeX//gn6E=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-493-NqHi6711NNak4qnjwi0yvQ-1; Wed, 23 Nov 2022 10:24:44 -0500
X-MC-Unique: NqHi6711NNak4qnjwi0yvQ-1
Received: by mail-qk1-f198.google.com with SMTP id bi42-20020a05620a31aa00b006faaa1664b9so22568769qkb.8
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 07:24:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+JIKrf57nj1kWRXglPfPJ258p/fyMgl7dlr5TafbPCE=;
        b=02QaG+pLgqkI7s2xNyIlXFU6hcpPKlJ75fnPBmsVHzOhssUXp557uB8lV5MhtiGfTc
         6d89JE3PjGKDCUbCZvRvWQ6WVT4sXNmsHYTZOHloqwC2FC4PBEegKmjUX7/M35fSz2XV
         TuwM9TVoPQ9BVPAPC5zwNUbIlvKMJYa+UUHQd83l+oz0KlcifBR61Z4725uJlgdrgSin
         LZTJPDlRHJLaE1nneKtGtdHPhTA6upaTP8LSseUpthYc3fDf9PZyuT/qRsg1E+u08CQ8
         upNWTp8Egd5fvJ5TMXLphD8N6xkC9Udd3TjDU/0Zz/rqDG5nXA1PRIPgB7p5BYItRB22
         pPbw==
X-Gm-Message-State: ANoB5pkFV/c+oDep0UBSM4t3doLbwe8jxq4cbSx5Yfm3XGEoH1ifUe/y
        28ISKBil+WSpBTU1YoHBRAN92F2veSuWHWQ1D7WNe4u3GEeW380mzWLC28Q+y4iJPg1/LjmvWQd
        i5T1GNlOGUSg/ZM2Z
X-Received: by 2002:a05:620a:1527:b0:6ec:ff06:8307 with SMTP id n7-20020a05620a152700b006ecff068307mr10509917qkk.683.1669217084253;
        Wed, 23 Nov 2022 07:24:44 -0800 (PST)
X-Google-Smtp-Source: AA0mqf71bOLl6p3QloT2gsNe/gsl/rWhKoQzcq0yCqIGJJaDaiJrvVCJtiQp8VwqkDgswaMsII218Q==
X-Received: by 2002:a05:620a:1527:b0:6ec:ff06:8307 with SMTP id n7-20020a05620a152700b006ecff068307mr10509885qkk.683.1669217083898;
        Wed, 23 Nov 2022 07:24:43 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id i5-20020a05622a08c500b003431446588fsm10141112qte.5.2022.11.23.07.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 07:24:43 -0800 (PST)
Date:   Wed, 23 Nov 2022 16:24:37 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        kernel <kernel@sberdevices.ru>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 1/3] test/vsock: rework message bound test
Message-ID: <20221123152437.gat3feinipkdsi3v@sgarzare-redhat>
References: <ba294dff-812a-bfc2-a43c-286f99aee0b8@sberdevices.ru>
 <c991dffd-1dbc-e1d1-b682-a3c71f6ce51c@sberdevices.ru>
 <20221121144602.gnrzlaatrnasaard@sgarzare-redhat>
 <e86656c2-079b-5223-cc69-d651cb846e24@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e86656c2-079b-5223-cc69-d651cb846e24@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 04:49:23PM +0000, Arseniy Krasnov wrote:
>On 21.11.2022 17:46, Stefano Garzarella wrote:
>> On Tue, Nov 15, 2022 at 08:50:36PM +0000, Arseniy Krasnov wrote:
>>> This updates message bound test making it more complex. Instead of
>>> sending 1 bytes messages with one MSG_EOR bit, it sends messages of
>>> random length(one half of messages are smaller than page size, second
>>> half are bigger) with random number of MSG_EOR bits set. Receiver
>>> also don't know total number of messages.
>>>
>>> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>>> ---
>>> tools/testing/vsock/control.c    |  34 +++++++++
>>> tools/testing/vsock/control.h    |   2 +
>>> tools/testing/vsock/util.c       |  13 ++++
>>> tools/testing/vsock/util.h       |   1 +
>>> tools/testing/vsock/vsock_test.c | 115 +++++++++++++++++++++++++++----
>>> 5 files changed, 152 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/tools/testing/vsock/control.c b/tools/testing/vsock/control.c
>>> index 4874872fc5a3..bed1649bdf3d 100644
>>> --- a/tools/testing/vsock/control.c
>>> +++ b/tools/testing/vsock/control.c
>>> @@ -141,6 +141,40 @@ void control_writeln(const char *str)
>>>     timeout_end();
>>> }
>>>
>>> +void control_writeulong(unsigned long value)
>>> +{
>>> +    char str[32];
>>> +
>>> +    if (snprintf(str, sizeof(str), "%lu", value) >= sizeof(str)) {
>>> +        perror("snprintf");
>>> +        exit(EXIT_FAILURE);
>>> +    }
>>> +
>>> +    control_writeln(str);
>>> +}
>>> +
>>> +unsigned long control_readulong(bool *ok)
>>> +{
>>> +    unsigned long value;
>>> +    char *str;
>>> +
>>> +    if (ok)
>>> +        *ok = false;
>>> +
>>> +    str = control_readln();
>>> +
>>> +    if (str == NULL)
>>
>> checkpatch suggests to use !str
>>
>>> +        return 0;
>>
>> Maybe we can just call exit(EXIT_FAILURE) here and remove the `ok`
>> parameter, since I'm not sure we can recover from this error.
>>
>>> +
>>> +    value = strtoul(str, NULL, 10);
>>> +    free(str);
>>> +
>>> +    if (ok)
>>> +        *ok = true;
>>> +
>>> +    return value;
>>> +}
>>> +
>>> /* Return the next line from the control socket (without the trailing newline).
>>>  *
>>>  * The program terminates if a timeout occurs.
>>> diff --git a/tools/testing/vsock/control.h b/tools/testing/vsock/control.h
>>> index 51814b4f9ac1..cdd922dfea68 100644
>>> --- a/tools/testing/vsock/control.h
>>> +++ b/tools/testing/vsock/control.h
>>> @@ -9,7 +9,9 @@ void control_init(const char *control_host, const char *control_port,
>>> void control_cleanup(void);
>>> void control_writeln(const char *str);
>>> char *control_readln(void);
>>> +unsigned long control_readulong(bool *ok);
>>> void control_expectln(const char *str);
>>> bool control_cmpln(char *line, const char *str, bool fail);
>>> +void control_writeulong(unsigned long value);
>>>
>>> #endif /* CONTROL_H */
>>> diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>>> index 2acbb7703c6a..351903836774 100644
>>> --- a/tools/testing/vsock/util.c
>>> +++ b/tools/testing/vsock/util.c
>>> @@ -395,3 +395,16 @@ void skip_test(struct test_case *test_cases, size_t test_cases_len,
>>>
>>>     test_cases[test_id].skip = true;
>>> }
>>> +
>>> +unsigned long djb2(const void *data, size_t len)
>>
>> I would add hash_ as a prefix (or suffix).
>>
>>> +{
>>> +    unsigned long hash = 5381;
>>> +    int i = 0;
>>> +
>>> +    while (i < len) {
>>> +        hash = ((hash << 5) + hash) + ((unsigned char *)data)[i];
>>> +        i++;
>>> +    }
>>> +
>>> +    return hash;
>>> +}
>>> diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>>> index a3375ad2fb7f..988cc69a4642 100644
>>> --- a/tools/testing/vsock/util.h
>>> +++ b/tools/testing/vsock/util.h
>>> @@ -49,4 +49,5 @@ void run_tests(const struct test_case *test_cases,
>>> void list_tests(const struct test_case *test_cases);
>>> void skip_test(struct test_case *test_cases, size_t test_cases_len,
>>>            const char *test_id_str);
>>> +unsigned long djb2(const void *data, size_t len);
>>> #endif /* UTIL_H */
>>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>>> index bb6d691cb30d..107c11165887 100644
>>> --- a/tools/testing/vsock/vsock_test.c
>>> +++ b/tools/testing/vsock/vsock_test.c
>>> @@ -284,10 +284,14 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
>>>     close(fd);
>>> }
>>>
>>> -#define MESSAGES_CNT 7
>>> -#define MSG_EOR_IDX (MESSAGES_CNT / 2)
>>> +#define SOCK_BUF_SIZE (2 * 1024 * 1024)
>>> +#define MAX_MSG_SIZE (32 * 1024)
>>> +
>>> static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
>>> {
>>> +    unsigned long curr_hash;
>>> +    int page_size;
>>> +    int msg_count;
>>>     int fd;
>>>
>>>     fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>>> @@ -296,18 +300,69 @@ static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
>>>         exit(EXIT_FAILURE);
>>>     }
>>>
>>> -    /* Send several messages, one with MSG_EOR flag */
>>> -    for (int i = 0; i < MESSAGES_CNT; i++)
>>> -        send_byte(fd, 1, (i == MSG_EOR_IDX) ? MSG_EOR : 0);
>>> +    /* Wait, until receiver sets buffer size. */
>>> +    control_expectln("SRVREADY");
>>> +
>>> +    curr_hash = 0;
>>> +    page_size = getpagesize();
>>> +    msg_count = SOCK_BUF_SIZE / MAX_MSG_SIZE;
>>> +
>>> +    for (int i = 0; i < msg_count; i++) {
>>> +        ssize_t send_size;
>>> +        size_t buf_size;
>>> +        int flags;
>>> +        void *buf;
>>> +
>>> +        /* Use "small" buffers and "big" buffers. */
>>> +        if (i & 1)
>>> +            buf_size = page_size +
>>> +                    (rand() % (MAX_MSG_SIZE - page_size));
>>> +        else
>>> +            buf_size = 1 + (rand() % page_size);
>>> +
>>> +        buf = malloc(buf_size);
>>> +
>>> +        if (!buf) {
>>> +            perror("malloc");
>>> +            exit(EXIT_FAILURE);
>>> +        }
>>> +
>>> +        /* Set at least one MSG_EOR + some random. */
>>> +        if (i == (msg_count / 2) || (rand() & 1)) {
>>> +            flags = MSG_EOR;
>>> +            curr_hash++;
>>> +        } else {
>>> +            flags = 0;
>>> +        }
>>> +
>>> +        send_size = send(fd, buf, buf_size, flags);
>>> +
>>> +        if (send_size < 0) {
>>> +            perror("send");
>>> +            exit(EXIT_FAILURE);
>>> +        }
>>> +
>>> +        if (send_size != buf_size) {
>>> +            fprintf(stderr, "Invalid send size\n");
>>> +            exit(EXIT_FAILURE);
>>> +        }
>>> +
>>> +        curr_hash += send_size;
>>> +        curr_hash = djb2(&curr_hash, sizeof(curr_hash));
>>> +    }
>>>
>>>     control_writeln("SENDDONE");
>>> +    control_writeulong(curr_hash);
>>
>> Why do we need to hash the size?
>>
>> Maybe we can send it without making the hash, anyway even if it wraps,
>> it should wrap the same way in both the server and the client.
>> (Or maybe we can use uin32_t or uint64_t to make sure both were
>> using 4 or 8 bytes)
>Hello, thanks for review. I think if we will use sum of message size(IIUC), in most
>paranoic case it won't guarantee message bounds control: single 4 bytes message
>could be read as 4 x 1 byte message(IIUC of course). Idea of hashing is simple:
>every iteration we do current_hash = hash(previous_hash + size of current message);
>I think this is more reliable and protects from case described above.

Okay, now I understand what it is for and agree that using hash is 
better.
Please add a comment to explain it.

>
>All other comments - ack.

Thanks,
Stefano

