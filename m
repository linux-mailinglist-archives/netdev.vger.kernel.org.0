Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1AF6C49B9
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 12:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjCVLzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 07:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjCVLzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 07:55:36 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5B64B80E
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 04:55:35 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id c18so22190813qte.5
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 04:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679486135;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7TL/xO5JdGYNRm5N56na9Q2M15OnV8PCEisd0LgIXRg=;
        b=A5MSj1oAYzJsx8hNlQnzj9i1zmwZhP61NhU+eqNIR/HcHlxLvKEej9GWmSAWPbpJut
         c+uY6rfzzfeLADg7F9/23pgXadisPo4HTx1LFZYMzftPh1d+NfWORPpmdLCMXstjrDub
         iGeieE/aDPcLYW+qs//kt9AwB+wPCrlIMSG7SNGacrVrT6mrBy9WXa4kKHxWjf4KygN2
         skFkL1gNDE1l1xiuzcz5j8bYsgFCwiDoL878nyXa95olE/qyFJs5NfUr+Wmc7+g80vh2
         WIqo3Gmh/zGBOG7mRpDIQYQtmU3cn8ta2tKRvv7KbtpcEHyfBFuHb6it6D+ssXttYqK9
         Ng/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679486135;
        h=mime-version:user-agent:references:message-id:date:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7TL/xO5JdGYNRm5N56na9Q2M15OnV8PCEisd0LgIXRg=;
        b=210ZHyMMvpPozzDsJ6ayn6sP0QMVLbgHHxk6xDZtexFfxPiQaYm7Q0d5Fx83DwV4KN
         bMKehc92s3kSDYEuRjnM2TTXL7q2KV5bBPHvGQJVjeOZeVQsF7wOdrs4eTAOSWXy9vPE
         +MxBfGgXgCPNSoKpT7QwXxL/VNuzcLzSO6EoiCS3f1gKlZNUCxSP3eQL5GNntmvVZcUb
         PxUT4Ybt6eS3wM34r5F1TFQAnYOxyf7fjXJovBHbXcZh2zj5PBcd/4VAIUhnpmcTwaF+
         D2CSVOQbNDFzF7rwMqE2bAUy4fMQrXzDqDO8QC/zmUNmQwTkAZ11G8jtAkFjEJ9yf079
         XSJw==
X-Gm-Message-State: AO0yUKWdYbe3VPYHyey3UvV92R0wyFo3z2FGAWvOZt1LO4s+ke4suF6B
        g4u3Q2jMPXU1w07j7VWkJ6I=
X-Google-Smtp-Source: AK7set8pG0QEioGx8l6s0g+LQ+vf8R0S5o1+X56AEencyF9IqRE7SdlXau0dygfaySHzOq2rK1ESNQ==
X-Received: by 2002:a05:622a:143:b0:3e3:867e:1801 with SMTP id v3-20020a05622a014300b003e3867e1801mr6335470qtw.31.1679486134699;
        Wed, 22 Mar 2023 04:55:34 -0700 (PDT)
Received: from imac ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id n69-20020a374048000000b00743a0096e8csm11199874qka.39.2023.03.22.04.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 04:55:34 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, donald.hunter@redhat.com
Subject: Re: [PATCH net-next v2 2/6] tools: ynl: Add struct parsing to nlspec
In-Reply-To: <20230321222245.48328d8b@kernel.org> (Jakub Kicinski's message of
        "Tue, 21 Mar 2023 22:22:45 -0700")
Date:   Wed, 22 Mar 2023 11:38:01 +0000
Message-ID: <m2bkklj9t2.fsf@gmail.com>
References: <20230319193803.97453-1-donald.hunter@gmail.com>
        <20230319193803.97453-3-donald.hunter@gmail.com>
        <20230321222245.48328d8b@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Sun, 19 Mar 2023 19:37:59 +0000 Donald Hunter wrote:
>> +class SpecStructMember(SpecElement):
>> +    """Struct member attribute
>> +
>> +    Represents a single struct member attribute.
>> +
>> +    Attributes:
>> +        type    string, kernel type of the member attribute
>
> We can have structs inside structs in theory, or "binary blobs" so this
> is really a subset of what attr can be rather than necessarily a kernel
> type?

Okay, so the schema currently defines the member types as u*, s* and
string. Does it make sense to add 'binary' and 'struct'?

To be clear, do you want me to drop the word 'kernel' from the
docstring, or something more?

>> +    """
>> +    def __init__(self, family, yaml):
>> +        super().__init__(family, yaml)
>> +        self.type = yaml['type']
>> +
>
> nit: double new line

Ack.
