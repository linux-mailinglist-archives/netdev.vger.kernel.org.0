Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA76066B35D
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 19:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbjAOSA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 13:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbjAOSAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 13:00:46 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D497F1287B;
        Sun, 15 Jan 2023 10:00:37 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o13so23563469pjg.2;
        Sun, 15 Jan 2023 10:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uLVx1PhJbb69yE3s3KgIdq0RqQc0Gk+6mf9XjMV+96c=;
        b=b+IFZSlJOOGNHKFVFNIVlHFFH05ZQ6SYunm6bgzx3iWEjLQblqLf3G7J4VSU3ijHoJ
         84640galOts/dyCBhuy00ep19E3wSClNWxWqFTJLEFhn8ijtHq0AwA1rT43LHaXnIrTl
         NP23v0LN3aW7Enl5jUbFNtssN9qlkCS1vU95AqqKg+2vhSf0bN7F3VqyqeSeJqcQocUC
         0l1VAOj/VekmszDZHUjS/SKYstCDS8lZcA7TVPpxjCsMPPV+nhFZZL97j2jh19cdsyvx
         LqepL99Ff4kLoQp7OywtvbQUkr/OBVadGDGmNgga9OBQOtytpDEM0DhUJgaKqr9xJE08
         3bTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uLVx1PhJbb69yE3s3KgIdq0RqQc0Gk+6mf9XjMV+96c=;
        b=S2OucZyhGICF6B/mVOnVzyiUrSdtrdL5SmAPLZnadmDuOwUH/RKXczD+XiD0gT/yFc
         bqVoXyFLa8bBAFQ/brGErmd6ebhxU6l0GKuUZ630FNnEzpiMjW5YrfCtO2oyPczFMEf3
         kX/KrCOyXssgyh3TC24Epwonc6+pfkLJRUT9x3VRy3/IyHaFRuMJEhmMAgEy3Cwh1szC
         lkwcGTh/Xd+peL3ZSXrZ0Fw6yjunMyj+iQHdBn0EytNREc6p6ZVyRUgpfIGQagQDuJGV
         MWHxIol/o/0LHqoTJe/8zIA1Enn1CEVmOc8wbCAzQlocYptkTo1Xj28uAlIJy8nSQDtb
         1IWg==
X-Gm-Message-State: AFqh2kooMwhEdIRhXhYCF//+lXF6Ci0DFpzrN4Lr4qKBbsoibJkHRWCN
        ZJBV3/IOug6M8ZzXomO7Ie0=
X-Google-Smtp-Source: AMrXdXvcWt5/3zIbUDPZNW6goqJJ6Anm2ZXen5iSfm0io/aJEY2pts8IGEgjxJaRtjTRzobS7Q7KoA==
X-Received: by 2002:a17:902:d5cd:b0:194:97d3:d724 with SMTP id g13-20020a170902d5cd00b0019497d3d724mr69570plh.23.1673805637244;
        Sun, 15 Jan 2023 10:00:37 -0800 (PST)
Received: from MacBook-Pro-6.local ([2620:10d:c090:400::5:df0a])
        by smtp.gmail.com with ESMTPSA id h18-20020a170902f55200b001929dff50a9sm17669877plf.87.2023.01.15.10.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 10:00:36 -0800 (PST)
Date:   Sun, 15 Jan 2023 10:00:34 -0800
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
Subject: Re: [PATCH HID for-next v2 9/9] HID: bpf: reorder BPF registration
Message-ID: <20230115180034.3djnmfkdiwomc74d@MacBook-Pro-6.local>
References: <20230113090935.1763477-1-benjamin.tissoires@redhat.com>
 <20230113090935.1763477-10-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113090935.1763477-10-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 10:09:35AM +0100, Benjamin Tissoires wrote:
> Given that our initial BPF program is not using any kfuncs anymore,
> we can reorder the initialization to first try to load it and then
> register the kfuncs. This has the advantage of not exporting kfuncs
> when HID-BPF is not working.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Alexei Starovoitov <ast@kernel.org>
