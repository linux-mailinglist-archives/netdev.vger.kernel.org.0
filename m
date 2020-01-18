Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD8F614164B
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 08:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgARHFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 02:05:15 -0500
Received: from mail-io1-f53.google.com ([209.85.166.53]:45056 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgARHFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 02:05:15 -0500
Received: by mail-io1-f53.google.com with SMTP id i11so28380804ioi.12;
        Fri, 17 Jan 2020 23:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=XGB9ioPK8jjcPFxGbOgL6Qa4BR0KREM1k1pzHd9czEA=;
        b=S5BIxlMDR5/QHqCVqLjU/fKN07pIvoQaxGjr7HeOT50bqy84YYv+G88H4QAybj7Nm4
         AOr7l4S6O5i9HuAqxmZzc+23zPCwqW26Qs1S1F8gLgM/SfOxgdopJIaVyUum3kAxqqFv
         Ru/i0GmdeifbjLBQoRrJPpuH7Su9ZLAIME66cZ+7ww8xECXv/W2HkLbsABU4dDXLFV5y
         YBZnfm0BbLEkuVjimmNw+DP7CW22giLExdWCSYOEL61n3Uo3UTMuX9vO4Q9Dy7Q8xOiB
         tMd6MuWTnfB1P0Zm2GVrFzQt+9wV7j5g+XYEWclKcOGj+bnyENeRpGKmidBvxRZ0Ow/U
         lEMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=XGB9ioPK8jjcPFxGbOgL6Qa4BR0KREM1k1pzHd9czEA=;
        b=izcBc2406XQXWLZpU54sIZKzfYc0hK0eo9wpWca/F0IGwbeWDNM/FVSqVc1Z77VWcJ
         EyDjD7H7XosCRqPqQdCZ+wgki+lkjobn70Fx51KqzDqiHikLOlPQBZj7Wxdj7XbMhV84
         0m5+yunrQdyqbkustrwR/YvFYFrS/UpJSCsEFDpOl9pZ+iNU5j3DdGJaIoxexd7y+IrC
         iF15ngozjTPFvqRpS/MKurY6f5p/hDYFtMIq3UmRwhzHOp3hIPy8eiH7MxlHv73SNDlQ
         YcKQvR1LSMzoQhN8bdBn7GgArHoLo0O4rsOQki5tNtktGQsqrK76tlAt85qH1vXw9q2Y
         kcgw==
X-Gm-Message-State: APjAAAUYQkRcgXOFjLYU2MDmrnxHkutub1CvpHyUF+RCncZoFXQfnJha
        pvcIPXKfkNfEmA74mN5dbZI=
X-Google-Smtp-Source: APXvYqwWWQnZBLVgN9gPJU7kJ6MlpFg/5hQkXyoQR7Qxf4v2R7wW9U0mMAh72iBNyuzFEUFrZ23kMw==
X-Received: by 2002:a02:c787:: with SMTP id n7mr36554176jao.85.1579331114157;
        Fri, 17 Jan 2020 23:05:14 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h23sm8605918ilf.57.2020.01.17.23.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 23:05:13 -0800 (PST)
Date:   Fri, 17 Jan 2020 23:05:05 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Petar Penkov <ppenkov.kernel@gmail.com>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Petar Penkov <ppenkov@google.com>
Message-ID: <5e22ae21c2e4e_33062b1a40ed85c029@john-XPS-13-9370.notmuch>
In-Reply-To: <20200117070533.402240-3-komachi.yoshiki@gmail.com>
References: <20200117070533.402240-1-komachi.yoshiki@gmail.com>
 <20200117070533.402240-3-komachi.yoshiki@gmail.com>
Subject: RE: [PATCH v2 bpf 2/2] selftests/bpf: Add test based on port range
 for BPF flow dissector
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yoshiki Komachi wrote:
> Add a simple test to make sure that a filter based on specified port
> range classifies packets correctly.
> 
> Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
> Acked-by: Petar Penkov <ppenkov@google.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
