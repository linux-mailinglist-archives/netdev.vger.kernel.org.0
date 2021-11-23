Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A56D45A3D8
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 14:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhKWNiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 08:38:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9654 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229939AbhKWNiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 08:38:15 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ANDWvV3030294;
        Tue, 23 Nov 2021 13:35:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=JhkYMBSB3TFJwO+8btge7mrVeNvkGW7dfXyrbtfjwXE=;
 b=ri1UKDFNNHoCXCg5mpYSNaeT2zPoj8xucNoM85jQP3wPvGTH5DsW9ixtcceiwp38I3g4
 wsZKZDpJcQAsHkDKSOzk1g8yGOPYavf5CNMQYyp08yISz9tqqMP4vTk2NB9AwpXdnjN5
 xeOJ4MthZRcV/vw086ugaXRjR26I3bJ39CbByHuZUmVqm5GcfG8zcCrx5RfZlYsNAZQM
 7prmGLXfTZi6Z1UhC2D05YySI/WpG3Wh2telp4eYHokZmEadu+Qcfdo3ryDkMqQ3SkBl
 Qm4JtWVUs0ZMbG7lZlYCKqjPWbuLDm+rOj0nVD9FIJI3+G6Cn8r3pfWPugqBc+FsSnZD 0g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgw5nnk65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 13:35:05 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ANDXc9I032676;
        Tue, 23 Nov 2021 13:35:05 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cgw5nnk5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 13:35:05 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AND94hI029337;
        Tue, 23 Nov 2021 13:22:34 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3cer9jr949-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Nov 2021 13:22:34 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ANDMW4415073734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 13:22:32 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01FF94C044;
        Tue, 23 Nov 2021 13:22:32 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83C934C046;
        Tue, 23 Nov 2021 13:22:31 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.0.71])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 23 Nov 2021 13:22:31 +0000 (GMT)
Date:   Tue, 23 Nov 2021 14:22:29 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 1/2] vhost/vsock: fix incorrect used length reported to
 the guest
Message-ID: <20211123142229.78edf43a.pasic@linux.ibm.com>
In-Reply-To: <20211122163525.294024-2-sgarzare@redhat.com>
References: <20211122163525.294024-1-sgarzare@redhat.com>
        <20211122163525.294024-2-sgarzare@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wRsvhxK9Lethzrk-8OpJ2qBrcMHq6Gmt
X-Proofpoint-ORIG-GUID: rEbIEAYwChKL5YaPQCZC2OyfUobdXAVK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_04,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111230076
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Nov 2021 17:35:24 +0100
Stefano Garzarella <sgarzare@redhat.com> wrote:

> The "used length" reported by calling vhost_add_used() must be the
> number of bytes written by the device (using "in" buffers).
> 
> In vhost_vsock_handle_tx_kick() the device only reads the guest
> buffers (they are all "out" buffers), without writing anything,
> so we must pass 0 as "used length" to comply virtio spec.
> 
> Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
> Cc: stable@vger.kernel.org
> Reported-by: Halil Pasic <pasic@linux.ibm.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

> ---
>  drivers/vhost/vsock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 938aefbc75ec..4e3b95af7ee4 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -554,7 +554,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
>  			virtio_transport_free_pkt(pkt);
>  
>  		len += sizeof(pkt->hdr);
> -		vhost_add_used(vq, head, len);
> +		vhost_add_used(vq, head, 0);
>  		total_len += len;
>  		added = true;
>  	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));

