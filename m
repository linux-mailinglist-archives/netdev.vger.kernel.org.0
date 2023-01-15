Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA0866B353
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 19:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbjAOSAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 13:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjAOSAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 13:00:17 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C5F125BE;
        Sun, 15 Jan 2023 10:00:16 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id y5so19474478pfe.2;
        Sun, 15 Jan 2023 10:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CJjlQpTkDVjrWWBvvNWY/0Ya5lkq+cPzSe4DReTa0g8=;
        b=eRO52hA0bKdCV5TnVmuBpeRcy72Z2PP5SoZoVQaSz+Wq0+M+Ak/WCHdAhZjgd2RBpc
         d4UfPNYERld5CpU4U4UeLuu/oN77G/7pfe0d1wo2qvcGynZYB28Tw7VjKnCuUkBIdLQi
         xY5TEG6vSMVPHJbaH/boLU/hLtUzrtMOExe41CtyvWUxSAxfThtr4lDIvY1ttwu+ptjz
         8giXNAhKeZq/R9wtW9E4ibwDWH4gHr8Ftt0U6mZS5kpZdMvDaX4/5x6RfcnhyLl9nEuW
         em24qaLKVMvi6ZSuh29FvpYFC3qQVS+JvcTx4piDXAjtssGob9jFXN3ro+hF0+zUv6VI
         x4Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CJjlQpTkDVjrWWBvvNWY/0Ya5lkq+cPzSe4DReTa0g8=;
        b=3nV1M0E1lLOsHqlFlLeuN/tcF+jVABZ8hHZdtJEbwA+Camg7io3IVOYhrQqtqOku9H
         AXxHNAbKLh3nVojpz7aG6lqRW7ik5xDBbGZoOsrrVzOybXCtIyyDgvXBHMPxrRGGw92P
         iS6eYmI1bjuvdhxcBkxzS1ZMTKILXdwdrvm2Wmz3CRqpCQycfhQCkswEdwhnoMQvuubq
         Od0KpfB6dKvY/VvAfU6G5Prqz0hg1qXKHr6Niokn2UZbDlpfpCRilATiH/bvCduiyw0i
         nAsfv5SzC/JlzoBgI3v1YWhIsB0CKrYrwKXh/lQ1EeaGaqgCaXQxNrf4DFK+aT+3qdKM
         EcoA==
X-Gm-Message-State: AFqh2ko9dyiTmbYGV4ZR/cI2eyAfbg3hUNPhWbiL1sCR/ZUZln0XNaQi
        OoKos0EAugtdPZ+I47PlL2s=
X-Google-Smtp-Source: AMrXdXu0j6Cc/YUL7C33WjfeM7h3IBmMYUw3dNhGaP+D/S2WbNIarTykh5stjvWsu0iuQZ0JNWm7aw==
X-Received: by 2002:a62:4e8e:0:b0:583:3d70:3661 with SMTP id c136-20020a624e8e000000b005833d703661mr30396565pfb.9.1673805615859;
        Sun, 15 Jan 2023 10:00:15 -0800 (PST)
Received: from MacBook-Pro-6.local ([2620:10d:c090:400::5:df0a])
        by smtp.gmail.com with ESMTPSA id f13-20020aa7968d000000b0056b4c5dde61sm4845267pfk.98.2023.01.15.10.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 10:00:15 -0800 (PST)
Date:   Sun, 15 Jan 2023 10:00:12 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH HID for-next v2 8/9] HID: bpf: clean up entrypoint
Message-ID: <20230115180012.x6ti4cyfp7odaa2b@MacBook-Pro-6.local>
References: <20230113090935.1763477-1-benjamin.tissoires@redhat.com>
 <20230113090935.1763477-9-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113090935.1763477-9-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 10:09:34AM +0100, Benjamin Tissoires wrote:
> We don't need to watch for calls on bpf_prog_put_deferred(), so remove
> that from the entrypoints.bpf.c file.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Alexei Starovoitov <ast@kernel.org>
