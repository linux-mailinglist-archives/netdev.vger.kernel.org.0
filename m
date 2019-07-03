Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBBF05D95A
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfGCAlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:41:18 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:41889 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfGCAlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:41:13 -0400
Received: by mail-pf1-f180.google.com with SMTP id m30so281981pff.8
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 17:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lJOlnWUQFDRhrYRw2RvCwT4119DMU6SV5drf3z1JWPk=;
        b=U+dImDZ0enMoOoZyHp4t+daISN9FS3PY1clUgSv5zzM+uM1rmeZ40NPIHZQHMyDK9h
         C0nCpsDv1SDIPLDMm9j1pwNg38uKCTrvg/8OBKQnrYN3qFokLZ+XVGl7FowydF6Y2Vy3
         5xVjlp1FTYNf6H0rEH6PoporbmNWLjpiLG6zMnUDKlRN28UpYXPsopAMrot52CfergsB
         UhmVkql9qeD7dr7R2SJGSDKqPrKvuhEs8aE0Uvbd+jKTyYQkj1Q0ioJ6vOoPOzjEeh96
         r1/txaNSNE7jQaglDC0YeFVl9lmcQc3g3oHmv5MrZ6AZwt8ZhTbnnnHhir/d2sA9PV4J
         8g9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lJOlnWUQFDRhrYRw2RvCwT4119DMU6SV5drf3z1JWPk=;
        b=Nq0A1HQHxjdWoIoxari1irTuPbuukczoNGwFeVrjJwhiUjyqPkGC91W6nI1VvD28Qa
         lb868YpSAlKrsPTPKkc/geG2UhMr3tdBF69fdThZDgZwIzMDX/qsmtyQjYlfSftHjhkI
         z2ktS5zXQPRGj09mpoLr/25ZiJIzfDSiKlehbIehkwXmIW5/dfYG+hS4yvo8dxxTydVs
         5AcDOmFO8WGGyVLWzR24ywpQh98AHYnx7/hMqh1n9tcFXuu7gP1D8Xyvly9oe/q0xChZ
         iyvoxR+9Qagyb96yOdrHEAD4M8b+qFQdAuV5xhaNaaLfLAmWHoXXsLoCMKrezzXkNs39
         MPuw==
X-Gm-Message-State: APjAAAVkMO7KJc2d1fdfHduIhJbV7c21nvc8DoXotV1Y2pfrHlvaqQUJ
        p7UW/aXXTjboja0Y80jbfiU=
X-Google-Smtp-Source: APXvYqwUst9FKrNGlEjpgqRBXNEg1Xw9Xv7/s7ayW9wVncpNSAeshqgTklC0xBc/z1Mh8Zm1fR9eMA==
X-Received: by 2002:a17:90a:346c:: with SMTP id o99mr8645664pjb.20.1562114473108;
        Tue, 02 Jul 2019 17:41:13 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k22sm245062pfk.157.2019.07.02.17.41.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 17:41:13 -0700 (PDT)
Date:   Tue, 2 Jul 2019 17:41:06 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, Alexander Aring <aring@mojatatu.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [RFC iproute2] netns: add mounting state file for each netns
Message-ID: <20190702174106.01f9266d@hermes.lan>
In-Reply-To: <20190630192933.30743-1-mcroce@redhat.com>
References: <20190630192933.30743-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 30 Jun 2019 21:29:33 +0200
Matteo Croce <mcroce@redhat.com> wrote:

> @@ -737,6 +746,14 @@ static int netns_add(int argc, char **argv, bool create)
>  	}
>  	close(fd);
>  
> +	fd = open(tmp_path, O_RDONLY|O_CREAT|O_EXCL, 0);
> +	if (fd < 0) {
> +		fprintf(stderr, "Cannot create namespace file \"%s\": %s\n",
> +			tmp_path, strerror(errno));
> +		goto out_delete;
> +	}
> +	close(fd);
> +
>  	if (create) {
>  		netns_save();
>  		if (unshare(CLONE_NEWNET) < 0) {
> @@ -757,6 +774,7 @@ static int netns_add(int argc, char **argv, bool create)
>  		goto out_delete;
>  	}
>  	netns_restore();
> +	unlink(tmp_path);

This looks like yet another source of potential errors and races.
What if the program is killed or other issues.

Maybe using abstract unix domain socket (which doesn't exist in filesystem
and auto-deletes on exit) would be better.
