Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAA51B26B5
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 14:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgDUMuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 08:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728719AbgDUMuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 08:50:51 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA89C061A10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:50:51 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id u5so13270184ilb.5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q0YdmabOC01lWaV0RBeV/+NKyVyRE7AfaSp+46/yeGk=;
        b=bK7jiJnEy5fTH7t5oO/SjUJXxxJsVRXcHsd+pag63MH5IKroU+QV8XtD9KDs1/VZJF
         gs4ExMqOj8Osqgfva8RLd02yQMrubCVpAgJaf8dVImzTfP+3heWAtP3yCxH82CIMU8HT
         5557lWmY0aOYZPlMQ3JUPwcb6DvRPS13ID/AeBXdXCNTjiEY0oQ7EWb/Cg6Fz/59yZMr
         Z3p9MeuLN79sf4fwZJPGjxGsiFc1OXrDwyDVLV+8jG0tHEG9ruPlbeKhhmhW048afwum
         CtfQqvYyv15hSmp65vrXdnCkqkaJr7JH/hyqWk5kcVTMwdZ7OlnllIFA9+Kx86/Ag3/7
         gR5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q0YdmabOC01lWaV0RBeV/+NKyVyRE7AfaSp+46/yeGk=;
        b=dDNVoQQcms5oLt4hj7xmfu8Mk2j1ajxZqfwjEME0alTSpB+/ZoeafJbutAUbYNvHUV
         NBSQvIh4ylwq/hewxHXQf6KZZezJkFZeqVAO0NbJ6QNXojoHzN1keJhf99+uQ9HntYRu
         QANmktod8TdkrGqL4YSvdsGoGQrolVPwhbFgE35o7anROOmO7LGPel4S2+9BBwkiC+a1
         FbjV5B8bs3UA+a1e8kzLg/o3wflm+nnfJpx6c+UOIbEzhTnMsKa8GK6ftFZhFyU8lV82
         QUD2b7eSOjGO7fba7nMzOykXl2JL5nTdomCKOvYWhKZDmo5ITtv9G1kBGvRvmjSv1V2J
         bCqg==
X-Gm-Message-State: AGi0Pubk17hZWJ5qY4RwN2T79uUhQM3aW62SPvWsmMYXNl3HRurMQGoQ
        dZf20NvOFMvTAdWSmdE8ZQ8=
X-Google-Smtp-Source: APiQypIyoffr5e/C5DFTDif8j9OihHFSHI596TmUIOczLf0G0XOJ7xA36gtEU1BkePn/Di3HdsnzLQ==
X-Received: by 2002:a92:d912:: with SMTP id s18mr20341217iln.30.1587473450421;
        Tue, 21 Apr 2020 05:50:50 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:294e:2b15:7b00:d585? ([2601:282:803:7700:294e:2b15:7b00:d585])
        by smtp.googlemail.com with ESMTPSA id z2sm894853ilz.88.2020.04.21.05.50.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 05:50:49 -0700 (PDT)
Subject: Re: [PATCH bpf-next 04/16] net: Add BPF_XDP_EGRESS as a
 bpf_attach_type
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200420200055.49033-1-dsahern@kernel.org>
 <20200420200055.49033-5-dsahern@kernel.org> <87ftcx9mcf.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <856a263f-3bde-70a7-ff89-5baaf8e2240e@gmail.com>
Date:   Tue, 21 Apr 2020 06:50:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87ftcx9mcf.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/20 4:14 AM, Toke Høiland-Jørgensen wrote:
> As I pointed out on the RFC patch, I'm concerned whether this will work
> right with freplace programs attaching to XDP programs. It may just be
> that I'm missing something, but in that case please explain why it
> works? :)

expected_attach_type is not unique to XDP. freplace is not unique to
XDP. IF there is a problem, it is not unique to XDP, and any
enhancements needed to freplace functionality will not be unique to XDP.
