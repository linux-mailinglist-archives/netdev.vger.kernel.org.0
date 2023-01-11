Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8785665465
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 07:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbjAKGLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 01:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjAKGLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 01:11:00 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BD5E7A;
        Tue, 10 Jan 2023 22:10:58 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d15so15723164pls.6;
        Tue, 10 Jan 2023 22:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QJ8uzvHCLOvyzentypgaCiRfqdglTQRAlPy00CWz9xA=;
        b=g/sM7zOYMeeyDiK7yprhxyxRBxRK06K18bzmQkZEmVpk1BMwzyL3ZcluVOL0zH3khe
         8yWjrThIW8x+2iulOJsrz5FltVDaIAJA7jyrcCk46amcdvXCW5J1UBsWCf2jU1g0JVwS
         JW7Nd+kRXxoTTqwYkou9dZ6hxtqQsGx8aG1A0hGqygCe/yO1jJ2hM9w42/ZJGyGgXF27
         ASoEvA+9DJ06pqm5qGj0DMIxxXz5XSTPYVKmRw0sbxWRIIpPWNq8P0jmr2VbGDwEMQMW
         o8zKZFzIfrm45iksynubmKNzySJXApg0phYpm8Zm8M64KIbhu6eVa3gCn/Wz7nlBJzR5
         MqvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QJ8uzvHCLOvyzentypgaCiRfqdglTQRAlPy00CWz9xA=;
        b=7PCCUcs80bwqtFgi7yKZ4JZVhbTxXHF8P2G2QXgMNKBZdP3z/8fcCGVkghxzZ+n+4r
         oZWwNU7HE1r7cOBoCnnkxW/m8QdBYEpKP4SxpZOG3HniKmiDgjEnGjNZm8OM9wzKZuKT
         eXEQmO5oiyTUJyNTgKL2/0CaZ0e0utJrJ/MGo2A4BZlsb68HqOFnkJV7lVWx0S00LtDN
         eH6pvlK7tlkh0LFyNQdfxHzeb7UpyD9sW1ywjb+Bf8xznc5Da11aBp7ioXmWdNRN29aT
         AGOMi+U/MvQ95W/nBiYCbjCJXaSNmH6guDNNQHnu+uMF5nAKPZa+mmMpHsY9v7fXO8x2
         psgw==
X-Gm-Message-State: AFqh2kr/BDxuf7h+259lr+yUm1gegpeGvMhuzubXygigtwJdjI8X3zlD
        kmqo/yNStJFYsQpKC0FHSf4=
X-Google-Smtp-Source: AMrXdXvYsWqIQBqEKtouxCmsLcgMEbysySaMzFBjF4HKpRMdkbH+QY/FrI6WTCvWi8ZpRpZi/gE91Q==
X-Received: by 2002:a17:902:ea02:b0:191:271f:477c with SMTP id s2-20020a170902ea0200b00191271f477cmr76771989plg.32.1673417457964;
        Tue, 10 Jan 2023 22:10:57 -0800 (PST)
Received: from macbook-pro-6.dhcp.thefacebook.com ([2620:10d:c090:400::5:863e])
        by smtp.gmail.com with ESMTPSA id g21-20020a170902869500b001745662d568sm9131804plo.278.2023.01.10.22.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 22:10:57 -0800 (PST)
Date:   Tue, 10 Jan 2023 22:10:54 -0800
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
Subject: Re: [PATCH HID for-next v1 6/9] HID: bpf: rework how programs are
 attached and stored in the kernel
Message-ID: <20230111061054.dqduab66plb6uzg2@macbook-pro-6.dhcp.thefacebook.com>
References: <20230106102332.1019632-1-benjamin.tissoires@redhat.com>
 <20230106102332.1019632-7-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106102332.1019632-7-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 11:23:29AM +0100, Benjamin Tissoires wrote:
>  
> +static void hid_bpf_link_release(struct bpf_link *link)
> +{
> +	struct hid_bpf_link *hid_link =
> +		container_of(link, struct hid_bpf_link, link);
> +
> +	__clear_bit(hid_link->index, jmp_table.enabled);
> +	schedule_work(&release_work);
> +}

...

> +	link->index = prog_idx;

I was super confused that you use prog_idx as a bit in jmp_table
and had to look into your tree what hid_bpf_jmp_table.c is doing.
Looks like it's not prog_id (which is prog->aux->id) that we know.
It's hid specific prog idx in that jmp table.
Maybe would be good to rename your prog_idx to something with 'hid' suffix or prefix?
or 'table' suffix or prefix ?
prog_table_idx ?

Other than that the patch set looking great.
I'm assuming removing call_hid_bpf_prog_put_deferred() and everything related
comes in the next set?
