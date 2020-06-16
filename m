Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4263E1FA97D
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 09:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgFPHGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 03:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgFPHGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 03:06:06 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97DDC05BD43;
        Tue, 16 Jun 2020 00:06:06 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id i25so434456iog.0;
        Tue, 16 Jun 2020 00:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=7UYkh8B3Fgzwx1rQ3OeB4igDdNX76egtj7f9JC6lupI=;
        b=OYYMuvehv/qPMmliSCDYK5QkafZl2sPnKeKmHj8GLN1GKJykOCKee0EQFmDR4rhhyr
         Hu4tnAFyWvABeM2j9ATpoj8htmFRFD9XufGunYw+0cZDPg6IN3Wnwq0iThzuXxF6YgrM
         F7IUv0QoOzG5l7kzjaF+ucbyQg3MGv9KvXrqJuzV62Et0VnBusvmq6qWozV4ULNHZUe+
         fkKXal0X5pFSA5UshG6yRt3dVjTWL/6twoZliH/AfuJJ6ds+I6Xibo9+jcdqFzhDPMJV
         hfz0/W3ZE/BkgfnjbWOL0xK2nFN68O8DjMpJa9C7Q4GsZ9xenEKVBQ5znwUkdcNWn48w
         kkpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=7UYkh8B3Fgzwx1rQ3OeB4igDdNX76egtj7f9JC6lupI=;
        b=WfrX7JnNNj9wpk9oqQ6selDeM3t9FyxkylvZ5ZqBQw6gpSDVIuL5INq8kFT2Gmszpt
         fyR6WF71eCxz7GbJn/wBa/HoHorQdnX2tnh5Id1Aiuw9qZ2gIbN2B9Uqirx9494vMDTi
         q2OdEmupFzqm7ISBrmk3IG00M67VGh8C1+a2QvYitDPXodbV98R6bs/zeYf29+c/3OJz
         wwUcZlwQSQPpKqGuU2brquu1UVKKTTO7l8bDj85pMJPyM5FC/SVu2EIDKqwKZkJDC3ud
         9NaEGRzgeI3g3wSaA8qNWTypvkJ0OcAQUARwYugDwxgeDL2mCdDIi9HLWEa3MylT2Yoc
         C8KQ==
X-Gm-Message-State: AOAM533Ksg7EQBdOBM5OepH9klMYngxREsPpNoU+qihiesOzpvrWch+7
        8gKJbHF+b2ma3FuGTifrOes=
X-Google-Smtp-Source: ABdhPJxo3yD7pmXL10U/+JtXAVaSOVZFsi1kh/FOJ+i5Ph63gDHX7AwLfZMQBRplKiCsZasV/bjIwQ==
X-Received: by 2002:a5e:d90c:: with SMTP id n12mr1611376iop.144.1592291165839;
        Tue, 16 Jun 2020 00:06:05 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j80sm9681504ili.65.2020.06.16.00.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 00:06:05 -0700 (PDT)
Date:   Tue, 16 Jun 2020 00:05:58 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Gaurav Singh <gaurav1086@gmail.com>, gaurav1086@gmail.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "(open list:BPF \\(Safe dynamic programs and tools\\))" 
        <netdev@vger.kernel.org>,
        bpf@vger.kernel.org (open list:BPF \(Safe dynamic programs and tools\)),
        "(open list:BPF \\(Safe dynamic programs and tools\\) open list)" 
        <linux-kernel@vger.kernel.org>
Message-ID: <5ee86f561cff7_4be02ab1b668a5b4e2@john-XPS-13-9370.notmuch>
In-Reply-To: <20200614184102.30992-1-gaurav1086@gmail.com>
References: <20200614184102.30992-1-gaurav1086@gmail.com>
Subject: RE: [PATCH] [bpf] xdp_monitor_user: Fix null pointer dereference
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gaurav Singh wrote:
> Memset() on the pointer right after malloc() can cause
> a null pointer dereference if it failed to allocate memory.
> Fix this by replacing malloc/memset with a single calloc().
> 
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
> ---
>  samples/bpf/xdp_monitor_user.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/samples/bpf/xdp_monitor_user.c b/samples/bpf/xdp_monitor_user.c
> index dd558cbb2309..ef53b93db573 100644
> --- a/samples/bpf/xdp_monitor_user.c
> +++ b/samples/bpf/xdp_monitor_user.c
> @@ -509,11 +509,8 @@ static void *alloc_rec_per_cpu(int record_size)
>  {
>  	unsigned int nr_cpus = bpf_num_possible_cpus();
>  	void *array;
> -	size_t size;
>  
> -	size = record_size * nr_cpus;
> -	array = malloc(size);
> -	memset(array, 0, size);
> +	array = calloc(nr_cpus, record_size);
>  	if (!array) {
>  		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
>  		exit(EXIT_FAIL_MEM);
> @@ -528,8 +525,7 @@ static struct stats_record *alloc_stats_record(void)
>  	int i;
>  
>  	/* Alloc main stats_record structure */
> -	rec = malloc(sizeof(*rec));
> -	memset(rec, 0, sizeof(*rec));
> +	rec = calloc(1, sizeof(*rec));
>  	if (!rec) {
>  		fprintf(stderr, "Mem alloc error\n");
>  		exit(EXIT_FAIL_MEM);
> -- 
> 2.17.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
