Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9FC574F47
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 15:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238309AbiGNNgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 09:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235944AbiGNNgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 09:36:46 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50D0528A2
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 06:36:45 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id o3-20020a17090a744300b001ef8f7f3dddso3096383pjk.3
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 06:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1KGi8hzs3JVmExGzAp1FgQ5HiiFDKdEHJQrmRugg7RE=;
        b=3bqlXQFzCFcdU2b8K18Dcx0EPGbu3DgTVENXm1gzt7OIN13aq+tu3i9MRcx0eKn0W/
         oWGvBAHf6MpPiv7a4pmCE3O1t8MON70gP8cngyQRLpqRWtvyb2BZWPULfFAhECF22DgV
         3wIaq3s0wO6gOR5u/urO2cArJjA28wiC9AB2MPzW8JNRnYg1M5zJBK6KUaQTkgV2Ojpb
         5jGUaf0dsh5lxI5hxvp9Xx94/vq3P6SiWvJqD9lAGHJTGAMpmRkUTtO6ULn/RVpsKHuu
         OgCxGMFe7cRn2GGqVDu/X71FnozJoCW+5z2Ri9lVnJKCSL1oWMrQSaqe4NirZJ3ySkGh
         QtJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1KGi8hzs3JVmExGzAp1FgQ5HiiFDKdEHJQrmRugg7RE=;
        b=xyVEF0KvJfjZbN9bOmZZL+rEMT3Z4L0U8OC02O/fV5uFFRk/YxJhnEfUKW9uXVH9C0
         9XPzoXAoyepq42KDryenRMc7WDolFs+CxY2skFZkumhUws9sTmyJFtznaRXjoqyFMJij
         TNozpb0g+Uri2AK8L/fyOc+urWxvHdYDdORafdfHXQNWf8YHbqlokEQ+oWyrXHEvNOaA
         LNZeLK9xYFW5zblJRDJzbpRQH8xfvaHJz4+snoIGD5SfpnQQNlDjuI0a4462OJvJyNfj
         7Zm5pEc+6+7JnvwvCYtAtLqZNYjqwecPvfkJgonJ2wpmiSODjD7zFzuCIuKhY8c5UHd3
         loPA==
X-Gm-Message-State: AJIora+mHmrKIIoimnnVWTZmcDMxqYsjUrB0zNr/d7oyAYeaheJKPJdX
        7VbC3tx8wiem6KXDmW1fE3JAvw==
X-Google-Smtp-Source: AGRyM1saZKUnOqdeeEX1IPXP+0vNME2o9wBVS+WydEif2fxcuIxP8aOjMhPwW6ZhX21u6S/o5TpnfA==
X-Received: by 2002:a17:90a:e547:b0:1ef:95c2:cefb with SMTP id ei7-20020a17090ae54700b001ef95c2cefbmr15775241pjb.225.1657805805274;
        Thu, 14 Jul 2022 06:36:45 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b3-20020a170902bd4300b0016c1efb9195sm1450242plx.298.2022.07.14.06.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 06:36:44 -0700 (PDT)
Message-ID: <c04892ba-61ca-2cb7-d390-3c3f5b4ff04a@kernel.dk>
Date:   Thu, 14 Jul 2022 07:36:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 for-next 3/3] io_uring: support multishot in recvmsg
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org, Kernel-team@fb.com
References: <20220714110258.1336200-1-dylany@fb.com>
 <20220714110258.1336200-4-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220714110258.1336200-4-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/22 5:02 AM, Dylan Yudaken wrote:
> Similar to multishot recv, this will require provided buffers to be
> used. However recvmsg is much more complex than recv as it has multiple
> outputs. Specifically flags, name, and control messages.
> 
> Support this by introducing a new struct io_uring_recvmsg_out with 4
> fields. namelen, controllen and flags match the similar out fields in
> msghdr from standard recvmsg(2), payloadlen is the length of the payload
> following the header.
> This struct is placed at the start of the returned buffer. Based on what
> the user specifies in struct msghdr, the next bytes of the buffer will be
> name (the next msg_namelen bytes), and then control (the next
> msg_controllen bytes). The payload will come at the end. The return value
> in the CQE is the total used size of the provided buffer.

Just a few minor nits (some repeat ones too), otherwise looks fine to
me. I can either fold these in while applying, or you can spin a v4. Let
me know!

> +static int io_recvmsg_multishot_overflow(struct io_async_msghdr *iomsg)
> +{
> +	unsigned long hdr;
> +
> +	if (check_add_overflow(sizeof(struct io_uring_recvmsg_out),
> +			       (unsigned long)iomsg->namelen, &hdr))
> +		return -EOVERFLOW;
> +	if (check_add_overflow(hdr, iomsg->controllen, &hdr))
> +		return -EOVERFLOW;
> +	if (hdr > INT_MAX)
> +		return -EOVERFLOW;
> +
> +	return 0;
> +}

Nobody checks the specific value of this helper, so we should either
actually do that, or just make this one return a true/false instead. The
latter makes the most sense to me.

> +static int io_recvmsg_prep_multishot(struct io_async_msghdr *kmsg, struct io_sr_msg *sr,
> +				     void __user **buf, size_t *len)
> +{

The line breaks here are odd, should be at 80 unless there's a good
reason for it to exceed it.

Function reads better now though with the cast.

> +static int io_recvmsg_multishot(
> +	struct socket *sock,
> +	struct io_sr_msg *io,
> +	struct io_async_msghdr *kmsg,
> +	unsigned int flags,
> +	bool *finished)
> +{

This is still formatted badly.

> +		if (req->flags & REQ_F_APOLL_MULTISHOT) {
> +			ret = io_recvmsg_prep_multishot(kmsg, sr,
> +							&buf, &len);

			ret = io_recvmsg_prep_multishot(kmsg, sr, &buf, &len);

this still would fit nicely on an unbroken line.

-- 
Jens Axboe

