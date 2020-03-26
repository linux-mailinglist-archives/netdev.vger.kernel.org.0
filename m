Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB89193858
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgCZGK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:10:29 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45949 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgCZGK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:10:29 -0400
Received: by mail-pl1-f193.google.com with SMTP id b9so1735550pls.12;
        Wed, 25 Mar 2020 23:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=41vVa28NJxXW3frZ8ek4ZKaeBQo5l+BXmc8fCo+GQhQ=;
        b=jf7oxa+8ikWokbp3JZVIehonc4tqf4fzrQU0IEfqJz2gvbbhTAg43SkOMs2WBR32mB
         UyeJIBFYpAc21pHcOfyn4/3pci0Ajb424PjlFKrOpMUPcWi/SM4DzUlcrC5tUGFY8QPc
         20KHesOkykqOUeUzXyOfIoOOEwznyHYBUpP8gRvQsKWS5vaoIVa4EVIEdKHj4E6yuTmd
         b6WLYgxC+/cK8tKKmKxp4j5Hdu2JqT6G1oUlcJpCsd7Ayo48vknsyORhO2SL7EQjhofZ
         vCIS7+x0TFmxIpjVnhL7QY858sQWO87Ev2obW0K9AlixRk0sDydQYlLWgls/5GooFrup
         Ht5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=41vVa28NJxXW3frZ8ek4ZKaeBQo5l+BXmc8fCo+GQhQ=;
        b=T5nnj1IJWwdAKvCSjSqzrGiEBr7Tznjidfh5wCtj94fuZgVfjzpYfNdaDS8lv5bFYj
         DIIQiQoiX4l7kfMYF+yF/FaEYlej2SkXAn008kLRdPBlUVHQW/lkacBJh5o95cbFtafH
         s+Oa03LrfEiRvYw+zvBjjQlW0yFzVNmzSfuzgErxpbiTB2CgTkkajB/r/E50TtAW7lAG
         7DWnAObbongPFhPtThqHYAaEtWBXMoTSFzXbq6b+cDH8dfLExBN2lUSn9pRryoLy/S+v
         /wBQdu6vGXrhKbpqog5NvRsxtU80MDZSGnQ0Cb6wTLV8E8uxfjL51FPyDm/h546eK/7t
         47xA==
X-Gm-Message-State: ANhLgQ3FPd2kGGviLw4WlZ9ZiOApF4okTSiwZFZe6MzMB+z3IF0Mgu0E
        8ye4GFN0r1VusKSTxyTlOvY=
X-Google-Smtp-Source: ADFU+vukcXyhls4yVA1H7ILY3oCs/UmLj2IPLDJuQPLRaTJ0yCqiM0VjOEDIglXlARmlZyc3N6l9gQ==
X-Received: by 2002:a17:902:aa97:: with SMTP id d23mr6691349plr.244.1585203026227;
        Wed, 25 Mar 2020 23:10:26 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:5929])
        by smtp.gmail.com with ESMTPSA id 11sm769566pfv.43.2020.03.25.23.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 23:10:24 -0700 (PDT)
Date:   Wed, 25 Mar 2020 23:10:22 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ecree@solarflare.com, yhs@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [bpf-next PATCH 02/10] bpf: verifer, refactor
 adjust_scalar_min_max_vals
Message-ID: <20200326061022.4c26jj6t6e7b4ilq@ast-mbp>
References: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
 <158507149518.15666.15672349629329072411.stgit@john-Precision-5820-Tower>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158507149518.15666.15672349629329072411.stgit@john-Precision-5820-Tower>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 10:38:15AM -0700, John Fastabend wrote:
> Pull per op ALU logic into individual functions. We are about to add
> u32 versions of each of these by pull them out the code gets a bit
> more readable here and nicer in the next patch.
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Great stuff!
I've applied this patch 2.
Then patch 3 and patch 8.

The other patches need a bit more work will reply there.
